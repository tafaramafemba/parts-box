class FaultCodesController < ApplicationController
  def search
    if params[:code].present?
      # Load the JSON file
      fault_codes = JSON.parse(File.read(Rails.root.join("app/assets/data/fault_codes.json")))

      # Find the matching code
      @result = fault_codes.find { |code| code["Code"].downcase == params[:code].downcase }

      # Handle no results found
      @result ||= { "Code" => params[:code], "Description" => "Code not found in the database." }
    end
  end
end

