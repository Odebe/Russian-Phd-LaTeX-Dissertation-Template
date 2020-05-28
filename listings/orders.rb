module Orders
  module Create
    class Endpoint
      include Dry::Monads[:result]
      include Dry::Monads::Do.for(:call)
      include Import[
        'order_contract',
        'create_order',
        'create_vm'
      ]

      def call(params)
        valid_params = yield order_contract.call(params)
        order = yield create_order.call(valid_params)
        _ = create_vm.call(order)

        Success(order)
      end
    end
  end

  module Shows
    class Endpoint
      include Import[
        'order_presenter',
        'orders_filter',
      ]

      def call(params)
        orders = orders_filter.call(params)
        orders.fmap { |o| order_presenter.call(o) }
      end
    end
  end

  module Deprovision
    class Endpoint
      include Dry::Monads[:result]
      include Dry::Monads::Do.for(:call)
      include Import[
        'find_order',
        'order_update'
      ]

      def call(params)
        order = yield find_order.call(params[:order])
        result = yield order_update.call(order, deprovision: true)

        Success(result)
      end
    end
  end

  module UpdateState
    class Endpoint
      include Dry::Monads[:result]
      include Dry::Monads::Do.for(:call)
      include Import[
        'find_order',
        'order_new_state',
        'save_new_state'
      ]

      def call(params)
        order = yield find_order.call(params[:order])
        result = yield order_update.call(order, state: params[:new_state])
         = save_new_state.call(order.id, params[:new_state])

        Success(result)
      end
    end
  end
end
