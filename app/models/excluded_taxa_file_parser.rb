class ExcludedTaxaFileParser

  attr_reader :data, :valid_format, :error
  
  def initialize(stream)
    @filename = ""
    @data = []
    @valid_format = true
    @error = ""

    if stream.instance_of?(String) # because of testing
      if stream =~ /\S+\/(\w+\.ex)$/
        @filename = $1
      end
      @data = File.open(stream,'r').readlines
    else
      @filename = stream.original_filename
      @data = stream.readlines
    end
    checkFormat
  end

  private
  def checkFormat
    for i in 0..@data.size-1
      line = @data[i]
      if line =~ /^\s*$/
        @error = "Error in #{@filename} line #{i+1}! Empty lines are not allowed.\n\n" 
        @valid_format = false
        break
      elsif line =~ /^\S+\s+\S+$/
        @error = "Error in #{@filename} line #{i+1}! Taxon has to be one word.\n\n"
        @valid_format = false
        break
      elsif !(line =~ /^\S+$/)
        @error = "Error in #{@filename} line #{i+1}!\n\n"
        @valid_format = false
        break
      end
    end
  end
end

