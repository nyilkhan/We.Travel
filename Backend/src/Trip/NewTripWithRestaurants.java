package Trip;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.stream.JsonReader;

/**
 * Servlet implementation class NewTripWithRestaurants
 */
@WebServlet("/NewTripWithRestaurants")
public class NewTripWithRestaurants extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public NewTripWithRestaurants() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//parsing response to JSON String 
		StringBuilder sb = new StringBuilder();
		BufferedReader reader1 = request.getReader();
		try {
			String line;
			while((line = reader1.readLine())!=null) {
				sb.append(line).append('\n');
			}
		} finally {
			reader1.close();
		}
		String info = sb.toString();
		//for debugging 
		//System.out.println(info);
		
		String longitude = "";
		String latitude = "";
		String hotel = "";
		String cost = "";
		String date_Begin = "";
		String date_End = "";
		String feature = "";
		String friend = "";
		String trip_name = "";
		String userName = "";
		String usernamesToAdd = "";
		Vector<Restaurant> restaurants = new Vector<Restaurant>();
		JsonReader reader = null;
		try {
			reader = new JsonReader(new StringReader(info));
			reader.beginObject();
			while(reader.hasNext()) {
				String parameterString = reader.nextName();
				if(parameterString.equals("longitude")) {
					longitude = reader.nextString();
				} else if(parameterString.equals("latitude")) {
					latitude = reader.nextString();
				} else if(parameterString.equals("hotel")) {
					hotel = reader.nextString();
				} else if(parameterString.equals("cost")) {
					cost = reader.nextString();
				} else if(parameterString.equals("date_Begin")) {
					date_Begin = reader.nextString();
				} else if(parameterString.equals("date_End")) {
					date_End = reader.nextString();
				} else if(parameterString.equals("feature")) {
					feature = reader.nextString();
				} else if(parameterString.equals("friend")) {
					friend = reader.nextString();
				} else if(parameterString.equals("trip_name")) {
					trip_name = reader.nextString();
				} else if(parameterString.equals("userName")) {
					userName = reader.nextString();
				} else if(parameterString.equals("usernamesToAdd")) {
					usernamesToAdd = reader.nextString();
				} else if(parameterString.equals("restaurants")) {
					 reader.beginArray();
					 while(reader.hasNext()) {
						 reader.beginObject();
						 String address = "";
						 String price = "";
						 String rating = "";
						 String image = "";
						 String link = "";
						 String name = "";
						 while(reader.hasNext()) {
							 String parameterString2 = reader.nextName();
							 if(parameterString2.equals("address")) {
								 address = reader.nextString();
							 } else if(parameterString2.equals("price")) {
								 price = reader.nextString();
							 } else if(parameterString2.equals("rating")) {
								 rating = reader.nextString();
							 } else if(parameterString2.equals("image")) {
								 image = reader.nextString();
							 } else if(parameterString2.equals("link")) {
								 link = reader.nextString();
							 } else if(parameterString2.equals("name")) {
								 name = reader.nextString();
							 } else {
								 reader.skipValue();
							 }
						 } reader.endObject();
						 Restaurant r = new Restaurant();
						 r.address = address;
						 r.price = price;
						 r.rating = rating;
						 r.link = link;
						 r.image = image;
						 r.name = name;
						 if(address.equals("")||price.equals("")||rating.equals("")||link.equals("")||image.equals("")||name.equals("")) {}
						 else {
							 restaurants.add(r);
						 }
					 }
					 reader.endArray();
				} else {
					reader.skipValue();
				}
			}
			reader.endObject();
		} finally {
			if(reader!=null)reader.close();
		}
		
		//establishing connection w database
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		PrintWriter pr = response.getWriter();
		String info_back = null;
		int tripID = -1;
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://csci201-final.cmudegxvolac.us-east-2.rds.amazonaws.com/csci201?user=csci201&password=jeffereymiller");
			//insert restaurants to database and get their IDs
			Vector<Integer> rID = new Vector<Integer>();
			for(int i = 0; i < restaurants.size();i++) {
				ps = conn.prepareStatement("INSERT INTO Restaurant(name,address,rating,price,image,link) VALUES (?,?,?,?,?,?)");
				ps.setString(1, restaurants.get(i).name);
				ps.setString(2, restaurants.get(i).address);
				ps.setString(3, restaurants.get(i).rating);
				ps.setString(4, restaurants.get(i).price);
				ps.setString(5, restaurants.get(i).image);
				ps.setString(6, restaurants.get(i).link);
				ps.execute();
				info_back = "{info: \""+restaurants.get(i).name+" added to Restaurant database\"}";
				pr.print(info_back);
				ps.close();
				//retrieve Id for restaurant update
				ps = conn.prepareStatement("SELECT MAX(idRestaurant) FROM Restaurant");
				rs = ps.executeQuery();
				while(rs.next()) {
					int tempId = rs.getInt("MAX(idRestaurant)");
					//System.out.println("Error line?");
					rID.add(tempId);
					info_back = "{info: \"Found the corresponding rID:"+tempId+"\"}";
					pr.print(info_back);
				}
				rs.close();
			}
			String rIDString = "";
			for(int i = 0; i< rID.size();i++) {
				rIDString += Integer.toString(rID.get(i)) + ",";
			}
			ps = conn.prepareStatement("INSERT INTO Trip(Longitude,Latitude,Hotel,Cost,Date_Begin,Date_End,Feature,Friend,TripName,Restaurants) VALUES (?,?,?,?,?,?,?,?,?,?)");
			ps.setString(1, longitude);
			ps.setString(2, latitude);
			ps.setString(3, hotel);
			ps.setString(4, cost);
			ps.setString(5, date_Begin);
			ps.setString(6, date_End);
			ps.setString(7, feature);
			ps.setString(8, friend);
			ps.setString(9, trip_name);
			ps.setString(10, rIDString);
			ps.execute();
			info_back = "{info: \"Trip added to database\"}";
			pr.print(info_back);
			ps.close();
			//retrieve tripID for current_trip update
			ps = conn.prepareStatement("SELECT MAX(TripID) FROM Trip");
			rs = ps.executeQuery();
			while(rs.next()) {
				tripID = rs.getInt("MAX(TripID)");
				//System.out.println("Error line?");
				info_back = "{info: \"Found the corresponding TripID:"+tripID+"\"}";
				pr.print(info_back);
			}
			rs.close();
			ps.close();
			if(usernamesToAdd==null) usernamesToAdd = "";
			String[] userNames = usernamesToAdd.split(",");
			if (userNames.length==0) {
				info_back = "{info: \"No need to add to other users\"}";
			} else {
				for(int i =0; i<userNames.length;i++) {
					//update the User table with the tripID
					//#1 get current_trip of user
					ps = conn.prepareStatement("SELECT current_trip FROM User WHERE username=?");
					ps.setString(1, userNames[i]);
					rs = ps.executeQuery();
					String currTrips = "";
					while(rs.next()) {
						currTrips = rs.getString("current_trip");
					}
					rs.close();
					ps.close();
					if(currTrips==null) {
						currTrips = "";
					}
					//#2 update current_trip
					String idFormatString = currTrips+Integer.toString(tripID)+",";
					ps = conn.prepareStatement("UPDATE User SET current_trip=? WHERE username=?");
					ps.setString(1, idFormatString);
					ps.setString(2, userNames[i]);
					ps.execute();
					info_back = "{info: \"TripID:"+tripID+" added to username:"+userName+"\"}";
				}
			} //update the User table with the tripID
			//#1 get current_trip of user
			ps = conn.prepareStatement("SELECT current_trip FROM User WHERE username=?");
			ps.setString(1, userName);
			rs = ps.executeQuery();
			String currTrips = "";
			while(rs.next()) {
				currTrips = rs.getString("current_trip");
			}
			rs.close();
			ps.close();
			if(currTrips==null) {
				currTrips = "";
			}
			//#2 update current_trip
			String idFormatString = currTrips+Integer.toString(tripID)+",";
			ps = conn.prepareStatement("UPDATE User SET current_trip=? WHERE username=?");
			ps.setString(1, idFormatString);
			ps.setString(2, userName);
			ps.execute();
			info_back = "{info: \"TripID:"+tripID+" added to username:"+userName+"\"}";
			pr.print(info_back);
		} catch (SQLException sqle) {
			System.out.println("sqle: " + sqle.getMessage());
		} catch (ClassNotFoundException cnfe) {
			System.out.println("cnfe: " + cnfe.getMessage());
		} finally {
			try {
				if (pr != null) pr.close();
				if (rs != null) rs.close();
				if (ps != null) ps.close();
				if (conn != null) conn.close();
			} catch (SQLException sqle) {
				System.out.println("sql closing studd: " + sqle.getMessage());
			}
		}
	}
}

class Restaurant {
	public String restaurantId;
	public String address;
	public String price;
	public String rating;
	public String image;
	public String link;
	public String name;
}

/*System.out.println(longitude);
System.out.println(latitude);
System.out.println(hotel);
System.out.println(cost);
System.out.println(date_Begin);
System.out.println(date_End);
System.out.println(feature);
System.out.println(friend);
System.out.println(flight);
System.out.println(userName);
System.out.println(usernamesToAdd);

for(int i =0; i <restaurants.size();i++) {
	System.out.println(i+ ": ");
	System.out.println(restaurants.get(i).address);
	System.out.println(restaurants.get(i).price);
	System.out.println(restaurants.get(i).rating);
	System.out.println(restaurants.get(i).image);
	System.out.println(restaurants.get(i).link);
	System.out.println(restaurants.get(i).name);
	System.out.println();
}*/
