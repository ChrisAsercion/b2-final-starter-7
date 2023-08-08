class HolidayService
  def holiday
    response = HTTParty.get('https://date.nager.at/api/v3/NextPublicHolidays/US')
    JSON.parse(response.body).take(3)

  end
end