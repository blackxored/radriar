module Radriar
  module Roar::Representers
    include Roar::Links
    mattr_accessor :representer_namespace
    mattr_accessor :hypermedia

    def represent(*args)
      opts = args.last.is_a?(Hash) ? args.pop : {}
      raise ArgumentError.new("nil can't be represented") unless args.first

      unless opts[:with]
        infered = infer_representer(args)
        if infered
          opts[:with] = infered
        else
          raise ArgumentError.new(
            "Can't infer representer, need to specify :with option for class #{klazz}"
          )
        end

        with = options[:with]

        if with.is_a?(Symbol)
          with = "#{representer_namespace}::#{with.to_s.classify}".constantize
        end

        if with.is_a?(Class)
          with.new(*args)
        elsif args.length > 1
          raise ArgumentError.new("Can't represent using module with more than one argument")
        else
          representable = args.first.extend(with)
          if opts[:represent]
            # TODO: workaround for not having as_json
            JSON.parse(reprsentable.to_json(opts[:represent]))
          else
            representable
          end
        end
      end
    end

    def represent_each(collection, *args, represent: nil, context: nil)
      result = {}
      unless collection.empty?
        result = add_links(context) if context
        result['total'] = collection.size
        result['_embedded'] = {
          collection.first.class.name.pluralize.downcase.to_sym =>
            represent_collection(collection, *args)
        }
      end
      result
    end

    def represent_collection(collection, *args)
      # TODO: try with roar 1.8
      # collection.map { |item| represent(item, *args) }
      collection.map { |item| JSON.parse(represent(item, *args).to_json)}
    end

    private
    def infer_representer(args)
      klazz = args.first.class.name
      "#{self.represented_namespace}::#{klazz}".safe_constantize
    end
  end
end
