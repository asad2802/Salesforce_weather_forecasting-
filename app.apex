

public with sharing class WeatherDetailsClass {

    public class DailyForecast {
        @AuraEnabled public String dayLabel;
        @AuraEnabled public String temperature;
        @AuraEnabled public String description;
        @AuraEnabled public String iconUrl;
    }

    @AuraEnabled
    public static List<DailyForecast> fetch5DayForecast(String cityName) {
        List<DailyForecast> forecastList = new List<DailyForecast>();
        try {
            String apiKey = '4b0a75964130c7760b16b98b17c13085';
            String endpoint = 'https://api.openweathermap.org/data/2.5/forecast?q=' +
                              EncodingUtil.urlEncode(cityName, 'UTF-8') +
                              '&appid=' + apiKey +
                              '&units=metric';

            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('GET');
            HttpResponse res = http.send(req);

            if (res.getStatusCode() == 200) {
                Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                List<Object> listData = (List<Object>) result.get('list');
                Set<String> addedDates = new Set<String>();

                for (Object entry : listData) {
                    Map<String, Object> forecastEntry = (Map<String, Object>) entry;
                    String dt_txt = (String) forecastEntry.get('dt_txt');
                    String dateOnly = dt_txt.split(' ')[0];

                    if (!addedDates.contains(dateOnly)) {
                        addedDates.add(dateOnly);

                        Map<String, Object> main = (Map<String, Object>) forecastEntry.get('main');
                        List<Object> weatherList = (List<Object>) forecastEntry.get('weather');
                        Map<String, Object> weather = (Map<String, Object>) weatherList[0];

                        DailyForecast daily = new DailyForecast();
                        daily.dayLabel = dateOnly;
                        daily.temperature = String.valueOf(main.get('temp'));
                        daily.description = (String) weather.get('description');
                        String iconCode = (String) weather.get('icon');
                        daily.iconUrl = 'https://openweathermap.org/img/wn/' + iconCode + '@2x.png';

                        forecastList.add(daily);

                        if (forecastList.size() == 5) break;
                    }
                }
            }
        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
        }
        return forecastList;
    }
}
