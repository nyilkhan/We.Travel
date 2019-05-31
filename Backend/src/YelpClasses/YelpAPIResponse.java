package YelpClasses;
import java.io.BufferedReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.json.simple.JSONObject;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;


//Class to handle Yelp API calls, limits to 5 businesses 
public class YelpAPIResponse {
	public Example results;
	
	
	final String LIMIT = "5";
	//Appends search term and search location/position to URL
	//If searching by location, use lat=0 and lon=0
	//If searching by position, use city=null
	public String appendResponse(String term, String city, double lat, double lon) {
		String yelpURLPart1 = "";
		if(city != null) {
			yelpURLPart1 = "https://api.yelp.com/v3/businesses/search?term=";
			String yelpURLPart2 = "&location=";
			yelpURLPart1 += term;
			yelpURLPart2 += city;
			yelpURLPart1 += yelpURLPart2;
		}
		else
		{
			yelpURLPart1 = "https://api.yelp.com/v3/businesses/search?term=";
			String yelpURLPart2 = "&latitude=";
			String yelpURLPart3 = "&longitude=";
			yelpURLPart1 += term;
			yelpURLPart2 += lat;
			yelpURLPart3 += lon;
			yelpURLPart1 += yelpURLPart2 + yelpURLPart3;
		}
		yelpURLPart1 += "&limit=" + LIMIT;
		return yelpURLPart1;
		//example URL:
		//https://api.yelp.com/v3/businesses/search?term=delis&latitude=37.786882&longitude=-122.399972
	}
	/*
	public String getResponse(String term, String city, double lat, double lon) {
		//Yelp business URL
		String yelpURL = appendResponse(term, city, lat, lon);
		//API key
		String API_KEY = "gkuwONJ0AKVfiWt9RiXWkHudy9md7X4i70xOCTqGLvJaningxKL0lPxaC0K6qKvTMvCAKN-ffsSNfOZ8OuoARdq3JlgPWQTJ_cwhZogYkDIL6BPwe3Sb-KVkOg6dXHYx";
		String response = "";
		HttpURLConnection con = null;
		BufferedReader in = null;
		try {
			URL apiURL = new URL(yelpURL);
			con = (HttpURLConnection) apiURL.openConnection();
			con.setRequestMethod("GET");
			con.setDoOutput(true);
			con.setRequestProperty("Authorization", "Bearer " + API_KEY);
			in = new BufferedReader(new InputStreamReader(con.getInputStream()));
			String inputLine;
			String content = new String();
			while ((inputLine = in.readLine()) != null) {
				content+=inputLine;
			}
			//
			//Line for debugging purposes:
			System.out.println(content);
			//
			response = content;
		} catch (MalformedURLException mue) {
			System.out.println("mue: " +mue.getMessage());
		} catch (IOException ioe) {
			System.out.println("ioe: " +ioe.getMessage());
		} finally {
			try {
				if(in!=null) in.close();
				if(con!=null) con.disconnect();
			} catch (IOException ioe) {
				System.out.println("ioe closing stuff: " +ioe.getMessage());
			}
		}
		return response;
	}*/
	//this one creates the array of results businesses
	public void searchResults(String term, String city, double lat, double lon) {
		//Yelp business URL
		String yelpURL = appendResponse(term, city, lat, lon);
		//API key
		String API_KEY = "gkuwONJ0AKVfiWt9RiXWkHudy9md7X4i70xOCTqGLvJaningxKL0lPxaC0K6qKvTMvCAKN-ffsSNfOZ8OuoARdq3JlgPWQTJ_cwhZogYkDIL6BPwe3Sb-KVkOg6dXHYx";
		//String response = "";
		HttpURLConnection con = null;
		BufferedReader in = null;
		
		try {
			URL apiURL = new URL(yelpURL);
			con = (HttpURLConnection) apiURL.openConnection();
			con.setRequestMethod("GET");
			con.setDoOutput(true);
			con.setRequestProperty("Authorization", "Bearer " + API_KEY);
			in = new BufferedReader(new InputStreamReader(con.getInputStream()));
			Gson gs = new GsonBuilder().create();
			Example exampleArr = gs.fromJson(in, Example.class);
			this.results = exampleArr; //new ArrayList<> (Arrays.asList(exampleArr));
			
		}catch(MalformedURLException mue) {
			System.out.println("mue: " +mue.getMessage());
		} catch (IOException e) {
			e.printStackTrace();
		}finally {
			try {
				if(in!=null) in.close();
				if(con!=null) con.disconnect();
			} catch (IOException ioe) {
				System.out.println("ioe closing stuff: " +ioe.getMessage());
			}
		}
				
	}
	
	public JSONObject createString(Business restaurant) {
		JSONObject obj = new JSONObject();
		
		obj.put("Name",restaurant.getName());
		obj.put("Price",restaurant.getPrice());
		obj.put("Rating",Double.toString(restaurant.getRating()));
		obj.put("Address",restaurant.getLocation().getAddress1()+" "+restaurant.getLocation().getCity()+" "+restaurant.getLocation().getCountry());
		obj.put("Image",restaurant.getImageUrl());
		obj.put("URL",restaurant.getUrl());
		
		String json = obj.toString();
		return obj;
	}
	
	//main method to test code
	public static void main(String[] args) {
		YelpAPIResponse ex = new YelpAPIResponse();
		//ex.getResponse("sushi", null, 37.786882, -122.399972);
		ex.searchResults("sushi", null, 37.786882040234, -122.39997200234);
		
		
		List<Business> list1 = ex.results.getBusinesses();
		JSONObject[] jArr = new JSONObject[5];
		for(int i = 0;i < list1.size();i++) {
			JSONObject st = ex.createString(list1.get(i));
			jArr[i] = st;
			//System.out.println(st);
		}
		for(int i = 0;i < list1.size();i++) {
			System.out.println(jArr[i]);
		}
		
	}
}