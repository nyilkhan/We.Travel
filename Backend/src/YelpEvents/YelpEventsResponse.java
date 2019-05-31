package YelpEvents;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.List;

import org.json.simple.JSONObject;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;


public class YelpEventsResponse {
	final String LIMIT = "5";
	public Example results;
	
	
	public String appendResponse(String categories, String city, double lat, double lon) {
		String yelpURLPart1 = "";
		if(city != null) {
			yelpURLPart1 = "https://api.yelp.com/v3/events?categories=";
			String yelpURLPart2 = "&location=";
			yelpURLPart1 += categories;
			yelpURLPart2 += city;
			yelpURLPart1 += yelpURLPart2;
		}
		else
		{
			yelpURLPart1 = "https://api.yelp.com/v3/events?categories=";
			String yelpURLPart2 = "&latitude=";
			String yelpURLPart3 = "&longitude=";
			yelpURLPart1 += categories;
			yelpURLPart2 += lat;
			yelpURLPart3 += lon;
			yelpURLPart1 += yelpURLPart2 + yelpURLPart3;
		}
		yelpURLPart1 += "&limit=" + LIMIT;
		return yelpURLPart1;
		//example URL:
		//https://api.yelp.com/v3/businesses/search?term=delis&latitude=37.786882&longitude=-122.399972
	}
	
	
	
	public String getResponse(String term, String city, double lat, double lon) {
		//Yelp business URL
		String yelpURL = appendResponse(term, city, lat, lon);
		//API key
		String API_KEY = "wMRmbiZN8cDK7hDhK-DNvT-flZjRUTsjX4C2_IYQlrHGphopp1Trt2E5h0sbNYpD80n92LmqjoN7Iq6ofGDBFyqjhSAjI9IvgIdomNPGc9oCGorFullyf8gnB928XHYx";
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
	}
	
	
	
	public void searchResults(String term, String city, double lat, double lon) {
		//Yelp business URL
		String yelpURL = appendResponse(term, city, lat, lon);
		//API key
		String API_KEY = "wMRmbiZN8cDK7hDhK-DNvT-flZjRUTsjX4C2_IYQlrHGphopp1Trt2E5h0sbNYpD80n92LmqjoN7Iq6ofGDBFyqjhSAjI9IvgIdomNPGc9oCGorFullyf8gnB928XHYx";
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
	
	public JSONObject createString(Event event) {
		JSONObject obj = new JSONObject();
		
		obj.put("Name",event.getName());
		obj.put("Description", event.getDescription());
		obj.put("Is Free", event.getIsFree());
		obj.put("Cost", event.getCost());
		obj.put("URL",event.getEventSiteUrl());
		obj.put("Attending Count", event.getAttendingCount());
		obj.put("Address",event.getLocation().getAddress1()+" "+event.getLocation().getCity()+" "+event.getLocation().getCountry());
		
		
		String json = obj.toString();
		return obj;
	}
	
	
	public static void main(String[] args) {
		YelpEventsResponse yer = new YelpEventsResponse();
		String res = yer.getResponse("music","Chicago",37.786882, -122.399972);
		System.out.println(res);
		
		yer.searchResults("film", "Los_Angeles", 37.786882, -122.399972);
		List<Event> list1 = yer.results.getEvents();

		JSONObject[] jArr = new JSONObject[5];
		for(int i = 0;i < list1.size();i++) {
			JSONObject st = yer.createString(list1.get(i));
			jArr[i] = st;
			//System.out.println(st);
		}
		for(int i = 0;i < list1.size();i++) {
			System.out.println(jArr[i]);
		}
	}
}
