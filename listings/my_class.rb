class MyClass
  att_reader :adapter

  def initialize(adapter)
    @adapter = adapter
  end

  def call(opts)
    adapter.call opts
  end
end
