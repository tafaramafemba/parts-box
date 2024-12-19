require 'httparty'
require 'nokogiri'

class CarPartsController < ApplicationController

  def search

    @query = params[:query]

    @car_part = CarPart.find_by(name: @query)


    if params[:query].present?      

      make = CarMake.find_by(name: params[:make])

      # Find car model by name if make is present
      model = make.present? ? make.car_models.find_by(name: params[:model]) : nil
      # Create the Facebook Marketplace search URL
      @facebook_url = build_facebook_url(params[:query], params[:make], params[:model], params[:year], params[:part_number], params[:location], params[:radius])

      @kijiji_url = build_kijiji_url(params[:query], params[:make], params[:model], params[:year], params[:part_number], params[:location], params[:radius])
      puts "Kijiji Url: #{@kijiji_url}"

      @napa_url = build_napa_url(params[:query], params[:make], params[:model], params[:part_number], params[:year], params[:vin])
     
      @ebay_results = fetch_ebay_results(params[:query], params[:make], params[:model], params[:year]) || []

      @autozone_url = build_autozone_url(params[:query], params[:make], params[:model], params[:part_number], params[:year], params[:vin])

      render :search
    end
  end

  def fetch_models
    if params[:make].present?
      make = CarMake.find_by(name: params[:make])
      models = make.present? ? make.car_models.pluck(:name, :id) : []
      render json: models
    else
      render json: [] # Return empty array if no make is selected
    end
  end
  

  private

  def build_facebook_url(query, make, model, year, part_number, location, radius)
    base_url = "https://www.facebook.com/marketplace/1000000000/search/?query="
    # Start with the main query
    search_terms = query.present? ? query : ""
    
    # Add make, model, year, and part number if they are present
    search_terms += "+#{make}" if make.present?
    search_terms += "+#{model}" if model.present?
    search_terms += "+#{year}" if year.present?
    search_terms += "+#{part_number}" if part_number.present?
    search_terms += "&location=#{location}" if location.present?
    search_terms += "&radius=#{radius}" if radius.present?
    
    # Return the full URL
    "#{base_url}#{search_terms}"
  end

  def build_kijiji_url(query, make, model, year, part_number, location, radius)
    # Kijiji URL base for car parts
    base_url = "https://www.kijiji.ca/b-cars-vehicles"
    
    # Use the postal code for Kijiji's location parameter (encode it properly for URLs)
    encoded_location = URI.encode_www_form_component(location)
  
    # Build the search terms
    search_terms = []
    search_terms << query if query.present?
    search_terms << make if make.present?
    search_terms << model if model.present?
    search_terms << year if year.present?
    search_terms << part_number if part_number.present?
  
    # Construct the final search query
    search_query = search_terms.join(" ").strip
  
    # URL encoding for search query
    encoded_query = URI.encode_www_form_component(search_query)
  
    # Build and return the full Kijiji search URL
    "#{base_url}/#{encoded_location}/#{encoded_query}/k0c27l1700228?radius=#{radius}"
  end
  
  def build_napa_url(query, make, model, part_number, year, vin)
    # Napa Canada URL base for search
    base_url = "https://www.napacanada.com/en/search"

    # Start building the search query with part number or name
    if part_number.present?
      search_terms = part_number.present? ? part_number : ''

          # URL encode the search query
      encoded_query = URI.encode_www_form_component(search_terms)

      # Start the base Napa URL with the text parameter (search term)
      napa_url = "#{base_url}?text=#{encoded_query}"

      # Add the referer parameter
      napa_url += "&referer=v2"

      napa_url

    else

      search_terms = query.present? ? query : ''

      search_terms += " #{make}" if make.present?
      search_terms += " #{model}" if model.present?
      search_terms += " #{year}" if year.present?
      search_terms += " #{vin}" if vin.present?

      
      # URL encode the search query
      encoded_query = URI.encode_www_form_component(search_terms)

      # Start the base Napa URL with the text parameter (search term)
      napa_url = "#{base_url}?text=#{encoded_query}"

      # Add the referer parameter
      napa_url += "&referer=v2"

      napa_url
    end

  end

  def build_autozone_url(query, make, model, part_number, year, vin)
    # Napa Canada URL base for search
    base_url = "https://www.autozone.com/en/search"

    # Start building the search query with part number or name
    if part_number.present?
      search_terms = part_number.present? ? part_number : ''

          # URL encode the search query
      encoded_query = URI.encode_www_form_component(search_terms)

      # Start the base Autozone URL with the text parameter (search term)
      autozone_url = "#{base_url}?text=#{encoded_query}"

      autozone_url

    else

      search_terms = query.present? ? query : ''

      search_terms += " #{make}" if make.present?
      search_terms += " #{model}" if model.present?
      search_terms += " #{year}" if year.present?
      search_terms += " #{vin}" if vin.present?

      
      # URL encode the search query
      encoded_query = URI.encode_www_form_component(search_terms)

      # Start the base Autozone URL with the text parameter (search term)
      autozone_url = "#{base_url}?text=#{encoded_query}"

      autozone_url
    end

  end


  def fetch_ebay_results(query, make, model, year)
    # Your eBay API App ID (replace with your actual App ID)
    app_id = "TafaraMa-c2c-PRD-474adffbb-fc800abe"  # Replace with your actual eBay App ID

    # eBay API Base URL for finding items
    ebay_url = "https://svcs.ebay.com/services/search/FindingService/v1"

    full_query = [query, make, model, year].compact.join(' ')


    # Construct the eBay API request parameters
    params = {
      'OPERATION-NAME' => 'findItemsAdvanced',
      'SERVICE-VERSION' => '1.13.0',   # eBay API version
      'SECURITY-APPNAME' => app_id,    # Your eBay App ID
      'GLOBAL-ID' => 'EBAY-ENCA',        # You can adjust this depending on the region you're targeting
      'keywords' => full_query,
      'paginationInput.entriesPerPage' => 10,  # Adjust number of results per page here
      'outputSelector' => 'PictureURLLarge',  # Ensure large picture URLs are included in the response
      'REST-PAYLOAD' => true              # Use REST payload
    }

    # Send the API request to eBay
    response = HTTParty.get(ebay_url, query: params)

    if response.success?
      Rails.logger.info("eBay API response: #{response.body.inspect}")
      # Parse the response as XML
      doc = Nokogiri::XML(response.body)
      namespace = { "ebay" => "http://www.ebay.com/marketplace/search/v1/services" }

      # Find the searchResult element
      search_result = doc.at_xpath("//ebay:searchResult", namespace)

      if search_result
        # Extract the items from the search result
        items = search_result.xpath("ebay:item", namespace).map do |item|
          {
            title: item.at_xpath("ebay:title", namespace)&.text,
            price: item.at_xpath("ebay:sellingStatus/ebay:currentPrice", namespace)&.text,
            currency: item.at_xpath("ebay:sellingStatus/ebay:currentPrice/@currencyId", namespace)&.text,
            url: item.at_xpath("ebay:viewItemURL", namespace)&.text,
            image_url: item.at_xpath("ebay:galleryURL", namespace)&.text,
            category: item.at_xpath("ebay:primaryCategory/ebay:categoryName", namespace)&.text
          }
        end
        return items
      else
        # No results found
        Rails.logger.warn("No search results found in the response.")
        return []
      end
    else
      # Log the error if the request fails
      Rails.logger.error("Error fetching eBay results: #{response.body}")
      return []
    end
  end




    
end
