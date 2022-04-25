class NoResultsSerializer

  def self.response
    {
      "message": "no results found",
      "results": []
    }
  end
end
