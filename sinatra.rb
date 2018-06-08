require 'sinatra'
require 'httparty'
require 'nokogiri'
require 'json'
require 'sinatra/reloader'

#########################################################
    #주소   
get '/menu' do # 이 주소로 요청이 왔을 때 해라!
                #컨트롤러가 어떻게 동작할지 넣어주면 됨.    
    menu = ["20층", "버거킹", "순대국", "김밥"]
    lunch, dinner = menu.sample(2)
    result = menu.sample(2)
    print("점심에는 " + lunch + ", 저녁에는 " + dinner + "을 드세요\n")
    "점심에는 " + result[0] + " / 저녁에는 " + result[1]
end

#########################################################
get '/lotto' do
               # 로또
                # 출력 : 이번주 추천 로또 번호 6자리
    number = (1..45).to_a
    lotto = number.sample(6).sort

    puts "이번주 추천 로또 번호 6자리" 
    puts lotto #+ "입니다." 이건 안됨.

    numbers = *(1..45)
    lotto = numbers.sample(6).sort

"이번주 추천 로또 숫자는" + lotto.to_s + "입니다."

end

#########################################################
get '/kospi' do
    
    require 'httparty'
    require 'nokogiri'
    response = HTTParty.get('http://finance.daum.net/quote/kospi.daum')
    kospi = Nokogiri::HTML(response)
    result = kospi.css("#hyenCost > b")

 "현재 코스피 지수는 " + result.text + "  포인트 입니다."

end

#########################################################
#로또 번호 

get '/checklotto' do
   
    url = "http://m.nlotto.co.kr/common.do?method=getLottoNumber&drwNo=809"
    #  로 요청을 보낼 것임
    lotto = HTTParty.get(url)
    result = JSON.parse(lotto)  # hash가 이뤄짐 / key 와 value
    bonus = result["bnusNo"]
    numbers = []
    
    result.each do |k,v|   # key, value를 담을 가변수를 만들어주어야함.
        if k.include?("drwtNo")   
            # 포함하고 있니?            # 같니?
            numbers << v  # numbers에 배열을 넣는다.
            
        end
    end
    
    my_numbers = *(1..45)
    my_lotto = my_numbers.sample(6).sort
    count = 0
    
    # my_numbers.each do |num|  # 값을 받아줄 가변수 num을 만들어주겠다.
    #     count += 1 if my_lotto.include? (num)  # 한줄짜리는 따로 { } 한써도 됨.
    # end
    
    my_lotto.each do |num|  # 값을 받아줄 가변수 num을 만들어주겠다.
        if numbers.include? (num)  # 한줄짜리는 따로 { } 한써도 됨.
            count += 1 
        end
    end
    
    puts "맞은 갯수는 " + count.to_s
    puts "내 번호는 " + my_lotto.sort.to_s
    puts "당첨 번호는 " + numbers.sort.to_s

    # 등수 확인
    
    if count == 6
        puts "축하드립니다. 1등에 당첨되셨습니다."
        
    elsif count == 5
        if my_lotto.include? (bonus)
            puts "축하드립니다. 2등에 당첨되셨습니다."
        else    
            puts "축하드립니다. 3등에 당첨되셨습니다."
        end
    elsif count == 4
        puts "축하드립니다. 4등에 당첨되셨습니다."
    elsif count == 3
        puts "축하드립니다. 5등에 당첨되셨습니다."     
    else
        puts "다음주에 계속..."    
    end
end
#    {"bnusNo":39,"firstAccumamnt":17528236500,"firstWinamnt":2921372750,"returnValue":"success","totSellamnt":74214104000,
#     "drwtNo3":15,"drwtNo2":11,"drwtNo1":6,"drwtNo6":40,"drwtNo5":23,"drwtNo4":17,
#     "drwNoDate":"2018-06-02","drwNo":809,"firstPrzwnerCo":6}
    
#################################################

get '/html' do
    "<html>
        <head></head>
        <body>
            <h3>Hello World 안녕하세요. </h3>
        </body>
    </html>"
end

get '/html_file' do  # 요청이 들어오면 파일을 보낼 것임
    @name = params[:name]      # 파라미터들이 다 들어있음.  [:심벌=상징] :name 자체가 변수가 됨.

    # 이 파일에 보낼 수 있으면 내용을 변화시킬 수 있을 것임.    
    #send_file 'views/my_first_html.html'
    erb :my_first_html
    #### 사용자가 입력한 변수를 파일에 받아 주는 것은 설정 완료됨.
    
    
    
end


#########################

get '/calculate' do
   
   num1 = params[:num1].to_f     #
   num2 = params[:num2].to_f 
   
   @sum     = num1 + num2
   @minus   = num1 - num2
   @multi   = num1 * num2
   @divide  = num1 / num2

    erb :calculate
    
end



