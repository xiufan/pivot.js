require 'faker'
require 'date'
require 'csv'
require 'pry'

class String
  def titleize
    self.split(/\s/).map(&:capitalize).join(' ')
  end
end

class DemoCSV
  attr_reader :cities, :header, :companies, :count
  def initialize(count, cities=nil)
    @count     = count
    @header    = ["last_name", "first_name", "employer", "billed_amount", "payment_amount", "invoice_date", "last_payment_date", "city", "state", "zip_code"]

    @companies = ["Acme, inc.","Widget Corp","123 Warehousing","Demo Company","Smith and Co.","Foo Bars","ABC Telecom","Fake Brothers","QWERTY Logistics","Sample Company",
                  "Sample, inc","Acme Corp","Mr. Sparkle","Globex Corporation","LexCorp","LuthorCorp","North Central Positronics","Omni Consimer Products",
                  "Praxis Corporation","Sombra Corporation","Wayne Enterprises","Wentworth Industries","ZiffCorp","Bluth Company","Strickland Propane","Water and Power",
                  "Western Gas & Electric","Mammoth Pictures","Mooby Corp","Gringotts"]

    @cities = CSV.table('./lib/csv/cities.csv')
  end

  def generate_csv
    CSV.generate do |csv|
      csv << header
      count.times do |i|
        invoice_date     = time_rand(Time.local(2010, 1, 1))
        last_billed_date = time_rand(Time.local(2010, 1, 1), invoice_date)
        city             = cities[rand(29)]

        csv << [ Faker::Name.last_name,
                 Faker::Name.first_name,
                 companies.sample,
                 "#{rand(1000)}.#{rand(10)}".ljust(2),
                 "#{rand(1000)}.#{rand(10)}".ljust(2),
                 invoice_date.to_date.rfc2822,
                 last_billed_date.to_date.rfc2822,
                 city[:city].titleize,
                 city[:state],
                 city[:zip] ]
      end
    end
  end


  def to_s
    puts generate_csv
  end

  def to_file(path)
    File.open(path,"w") {|f| f.write(generate_csv)}
  end

  def time_rand(from=0.0,to=Time.now)
    Time.at(from + rand * (to.to_f - from.to_f))
  end
end