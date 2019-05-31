package Trip;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

/**
 * Servlet implementation class GetPendingTripsInfo
 */
@WebServlet("/GetPendingTripsInfo")
public class GetPendingTripsInfo extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetPendingTripsInfo() {
        super();
        // TODO Auto-generated constructor stub
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		StringBuilder sb = new StringBuilder();
	    BufferedReader reader = request.getReader();
	    try 
	    {
	        String line;
	        while ((line = reader.readLine()) != null) 
	        {
	            sb.append(line).append('\n');
	        }
	    } 
	    finally 
	    {
	        reader.close();
	    }
	    String info = sb.toString();
	    //System.out.println("info is: " + info);
	    
	    // Parse JSON String
	    // json = "{\"username\":\"Peter\", \"password\": 123}";

	    Gson gson = new Gson();
	    userInfo information = gson.fromJson(info, userInfo.class);
        
        // Store in variable
        String username = information.username; 
        
        
        System.out.println(username);
       
        
        // info_back
        String info_back = null;
        
        // Contact database
        Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		PreparedStatement ps2 = null;
		ResultSet rs2 = null;
		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://csci201-final.cmudegxvolac.us-east-2.rds.amazonaws.com/csci201?user=csci201&password=jeffereymiller");
			ps = conn.prepareStatement("SELECT * FROM User WHERE username =?");
			ps.setString(1, username);
			rs = ps.executeQuery();
			String trips = "";
			String[] tripIds = null;
			Trip [] tripVec = null; //array of trips for the trips to return
			String [] restaurantIds = null;
			Restaurant[] restaurantVec = null;
			String restaurants;
			while(rs.next())
			{
				trips = rs.getString("pending_trip");
				if(trips == null) {
					trips = "";
				}
				tripIds = trips.split(",");
				tripVec = new Trip[tripIds.length];
			}
			if (trips== "")
			{
				info_back = "{info: \"trip doesn't exist\"}";
			}
			else
			{
				for(int i = 0; i < tripIds.length; i++) { //adds all the info into the trip objects
					Trip currTrip = new Trip();
					ps = conn.prepareStatement("SELECT * FROM Trip WHERE TripID =?");
					ps.setString(1, tripIds[i]);
					rs = ps.executeQuery();
					
					currTrip.tripId = tripIds[i];
					while(rs.next())
					{
						restaurants =  rs.getString("Restaurants");
						if(restaurants == null) {
							restaurants = "";
						}
						restaurantIds = restaurants.split(",");
						restaurantVec = new Restaurant[restaurantIds.length];
						
					
					for(int j = 0; j < restaurantIds.length; j++)
					{
						
						Restaurant newR = new Restaurant();
						ps2 = conn.prepareStatement("SELECT * FROM Restaurant WHERE idRestaurant =?");
						ps2.setString(1, restaurantIds[j]);
						rs2 = ps2.executeQuery();
						while(rs2.next())
						{
							newR.restaurantId = restaurantIds[j];
							newR.address = rs2.getString("address");
							newR.price = rs2.getString("price");
							newR.rating = rs2.getString("rating");
							newR.image = rs2.getString("image");
							newR.link = rs2.getString("link");
							newR.name = rs2.getString("name");
							System.out.println(newR.name);
							restaurantVec[j] = newR;
						}
						
						
					}
					currTrip.restaurants = restaurantVec;
					currTrip.tripName = rs.getString("TripName");
					currTrip.longitude = rs.getString("Longitude");
					currTrip.latitude = rs.getString("Latitude");
					currTrip.hotel = rs.getString("Hotel");
					currTrip.cost = rs.getString("Cost");
					currTrip.date_Begin = rs.getString("Date_Begin");
					currTrip.date_End = rs.getString("Date_End");
					currTrip.feature = rs.getString("Feature");
					currTrip.friend = rs.getString("Friend");
					tripVec[i] = currTrip;
					}
				}
				info_back  = gson.toJson(tripVec);
				
			}
		}
		catch (SQLException sqle)
		{
			System.out.println("sqle: " + sqle.getMessage());
		}
		catch (ClassNotFoundException cnfe)
		{
			System.out.println("cnfe: " + cnfe.getMessage());
		}
		finally
		{
			try
			{
				if (rs != null) {rs.close();}
				if (ps != null) {ps.close();}
				if (conn != null) {conn.close();}
			}
			catch(SQLException sqle)
			{
				System.out.println("sql closing studd: " + sqle.getMessage());
			}
		}
		
		// Send info back
		
		//System.out.print(info_back);
		PrintWriter pr = response.getWriter();
		pr.print(info_back);
		pr.close();
	}
}
