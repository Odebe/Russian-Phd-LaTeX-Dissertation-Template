module Vms
  module Create
    class Endpoint
      include Dry::Monads[:result]
      include Dry::Monads::Do.for(:call)
      include Import[
        'vm_contract',
        'openstack_adapter'
      ]

      def call(params)
        valid_params = yield vm_contract.call(params)
        vm = yield openstack_adapter.create_vm(valid_params)

        Success(vm)
      end
    end
  end

  module Show
    class Endpoint
      include Import[
        'vm_presenter',
        'openstack_adapter'
      ]

      def call(params)
        vm = yield openstack_adapter.find_vm(params)
        presenter = yield vm_presenter.call(vm)

        Success(presenter)
      end
    end
  end

  module Delete
    class Endpoint
      include Dry::Monads[:result]
      include Dry::Monads::Do.for(:call)
      include Import[
        'validate_deletion',
        'order_update'
      ]

      def call(params)
        order = yield validate_deletion.call(params)
        result = yield order_update.call(order, deprovision: true)

        Success(result)
      end
    end
  end
end
