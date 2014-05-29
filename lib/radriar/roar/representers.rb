module Radriar
  module Roar::Representers
    include Roar::Links
    mattr_accessor :hypermedia

    def represent(*args, with: nil, represent: nil, context: nil)
      representer = find_representer(args, with)
      options = {}

      if params[:fields].present?
        options[:include] = params[:fields].split(",").map(&:to_sym)
      end
      options.merge!(represent) if represent 

      if representer.is_a?(Class)
        represented = representer.new(*args)
      elsif args.length > 1
        raise ArgumentError.new("Can't represent using module with more than one argument")
      elsif representer.is_a?(Module)
        represented = args.first.extend(representer)
      else
        raise ArgumentError.new("Can't infer, instantiate or extend representer")
      end
 
      options[:exclude] = [:links] unless Radriar::Representable.hypermedia?
      represented.to_hash(options)
    end

    def represent_each(collection, *args, with: nil, represent: nil, context: nil)
      if Radriar::Representable.hypermedia?
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
      else
        represent_collection(collection, *args)
      end
    end

    def represent_collection(collection, *args)
      # TODO: try with roar 1.8
      # collection.map { |item| represent(item, *args) }
      collection.map { |item| JSON.parse(represent(item, *args).to_json)}
    end

    private
    def find_representer(args, with)
      raise ArgumentError.new("nil can't be represented") unless args.first

      unless with
        klazz = args.first.class.name
        infered = "#{representer_namespace}::#{klazz}".safe_constantize
        if infered
          representer = infered
        else
          raise ArgumentError.new(
            "Can't infer representer, need to specify :with option for class #{klazz}"
          )
        end
      end

      if with.is_a?(Symbol)
        "#{representer_namespace}::#{with.to_s.classify}".constantize
      else
        representer
      end
    end

    def representer_namespace
      Radriar::Representable.representer_namespace
    end
  end
end
