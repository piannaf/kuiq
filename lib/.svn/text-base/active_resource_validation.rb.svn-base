module ActiveResource::RealValidation
  def self.included(base) # :nodoc:
    base.class_eval { alias_method_chain :save, :real_validation }
  end
  def save_with_real_validation # :nodoc:
    validate if respond_to? :validate
    validate_on_create if new?  && respond_to?(:validate_on_create)
    validate_on_update if !new? && respond_to?(:validate_on_update)
    valid? ? save_without_validation : false
  rescue ResourceInvalid => error
    errors.from_xml(error.response.body)
    false
  end
end

# solves http://dev.rubyonrails.org/ticket/10985
ActiveResource::Base.send :include, ActiveResource::RealValidation