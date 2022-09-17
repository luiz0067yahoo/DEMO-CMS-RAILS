class DimensionsValidator < ActiveModel::EachValidator
	def validate_each(record, attribute, value)
		return if value.queued_for_write[:original].try(:path).blank?
		
		dimensions = Paperclip::Geometry.from_file(value.queued_for_write[:original].try(:path))
		_width = options[:width]
		_height = options[:height] 
		unless dimensions.width >= _width && dimensions.height >=_height
			record.errors.add(attribute, :dimensions_invalid,original_width:dimensions.width,original_height:dimensions.height,min_width:_width,min_height:_height)
			#record.errors.add(attribute, :dimensions_invalid)
		end
	end
end