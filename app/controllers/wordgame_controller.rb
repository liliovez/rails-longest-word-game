class WordgameController < ApplicationController

  def game
    @grid = Array.new(10) { ('A'..'Z').to_a[rand(26)] }
    @start_time = Time.now
  end

  def score
    start_time = params[:start_time].to_time
    @attempt = params[:attempt]
    attempt = params[:attempt]
    get_translation(attempt)
    end_time = Time.now
    @time_taken = end_time - start_time
    @score = (@time_taken > 60.0) ? 0 : attempt.size * (1.0 - @time_taken / 60.0)
  end


    def get_translation(attempt)
    attempt = params[:attempt]
    api_key = "YOUR_SYSTRAN_API_KEY"
      begin
        response = open("https://api-platform.systran.net/translation/text/translate?source=en&target=fr&key=#{api_key}&input=#{attempt}")
        json = JSON.parse(response.read.to_s)
        if json['outputs'] && json['outputs'][0] && json['outputs'][0]['output'] && json['outputs'][0]['output'] != attempt
          return json['outputs'][0]['output']
        end
      rescue
        if File.read('/usr/share/dict/words').upcase.split("\n").include? attempt.upcase
          return attempt
        else
          return nil
        end
      end
    end
  end

