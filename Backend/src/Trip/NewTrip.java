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
 * Servlet implementation class NewTrip:
 * Creates a new entry in the trip table and updates the user's table with the current trip id
 */
@WebServlet("/NewTrip")
public class NewTrip extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	public NewTrip() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//parsing response to JSON String 
		StringBuilder sb = new StringBuilder();
		BufferedReader reader = request.getReader();
		try {
			String line;
			while((line = reader.readLine())!=null) {
				sb.append(line).append('\n');
			}
		} finally {
			reader.close();
		}
		String info = sb.toString();
		//for debugging 
		System.out.println(info);
		//parsing JSON 
		Gson gson = new Gson();
		CustomTripForServlet tripInfo = gson.fromJson(info, CustomTripForServlet.class);
		//populating variables
		String longitude = tripInfo.longitude;
		String latitude = tripInfo.latitude;
		String hotel = tripInfo.hotel;
		String cost = tripInfo.cost;
		String date_Begin = tripInfo.date_Begin;
		String date_End = tripInfo.date_End;
		String feature = tripInfo.feature;
		String friend = tripInfo.friend;
		String flight = tripInfo.flight;
		String userName = tripInfo.userName;
		String usernamesToAdd = tripInfo.usernamesToAdd;
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
			//insert data into database
			ps = conn.prepareStatement("INSERT INTO Trip(Longitude,Latitude,Hotel,Cost,Date_Begin,Date_End,Feature,Friend,Flight) VALUES (?,?,?,?,?,?,?,?,?)");
			ps.setString(1, longitude);
			ps.setString(2, latitude);
			ps.setString(3, hotel);
			ps.setString(4, cost);
			ps.setString(5, date_Begin);
			ps.setString(6, date_End);
			ps.setString(7, feature);
			ps.setString(8, friend);
			ps.setString(9, flight);
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
			}
			//update the User table with the tripID
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

class CustomTripForServlet {
	public String tripId;
	public String longitude;
	public String latitude;
	public String hotel;
	public String cost;
	public String date_Begin;
	public String date_End;
	public String feature;
	public String friend;
	public String flight;
	public String userName;
	public String usernamesToAdd;
}
