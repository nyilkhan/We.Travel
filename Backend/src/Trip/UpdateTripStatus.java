package Trip;

import java.io.BufferedReader;
import java.io.IOException;
//import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

/**
 * Servlet implementation class UpdateTripStatus
 * This servlet checks if any pending trips need to move to current 
 * or if any current trips need to move to past or pending trips
 */
@WebServlet("/UpdateTripStatus")
public class UpdateTripStatus extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public UpdateTripStatus() {
        super();
        // TODO Auto-generated constructor stub
    }

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
		Gson gson = new Gson();
	    userInfo information = gson.fromJson(info, userInfo.class);
        // Store in variable
        String username = information.username; 
        //System.out.println(username); 
        // info_back
        //String info_back = null;
        // Contact database
        Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
        try {
        	Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://csci201-final.cmudegxvolac.us-east-2.rds.amazonaws.com/csci201?user=csci201&password=jeffereymiller");
			ps = conn.prepareStatement("SELECT pending_trip FROM User WHERE username =?");
			ps.setString(1, username);
			rs = ps.executeQuery();
			String trips = "";
			String[] tripIds = null;
			String [] tripDates = null;
			String moveToCurrent = "";
			String keepInPending = "";
			while(rs.next()) {
				trips = rs.getString("pending_trip");
				if(trips==null) trips="";	
				tripIds = trips.split(",");
				tripDates = new String[tripIds.length];
			}
			if (trips.isEmpty()) {
				//no pending 
				//info_back = "{info: \"no pending trips to look at\"}";
			} else {
				//need to check each trip to see if date begin has already happened 
				//if so, move to current trips
				//System.out.println("first:"+tripIds.length);
				for(int i = 0; i < tripIds.length; i++) { //adds all the info into the trip objects
					ps.close();
					rs.close();
					ps = conn.prepareStatement("SELECT Date_Begin FROM Trip WHERE TripID =?");
					ps.setString(1, tripIds[i]);
					rs = ps.executeQuery();
					rs.beforeFirst();
					rs.next();
					tripDates[i] = rs.getString("Date_Begin");
				}
				for(int i = 0; i < tripIds.length; i++) {
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
					Date dateOfTrip1 = sdf.parse(tripDates[i]);
					Calendar cal = Calendar.getInstance();
					String dateInString = "" + cal.get(Calendar.YEAR);
					dateInString += "-" + (cal.get(Calendar.MONTH)+1);
					dateInString += "-" + cal.get(Calendar.DATE);
					Date currentDate2 = sdf.parse(dateInString);
					if(dateOfTrip1.compareTo(currentDate2)<0) {
						//this trip needs to move to current trips
						moveToCurrent += tripIds[i]+",";
					} else {
						//this trip needs to stay
						keepInPending += tripIds[i]+",";
					}
				}
				//now update the database
				//first update pending trips with what needs to stay
				ps = conn.prepareStatement("UPDATE User SET pending_trip=? WHERE username=?");
				ps.setString(1, keepInPending);
				ps.setString(2, username);
				ps.execute();
				//retrieve the info from current trip section
				ps = conn.prepareStatement("SELECT current_trip FROM User WHERE username=?");
				ps.setString(1, username);
				rs = ps.executeQuery();
				String originalIDsOFCurrent = "";
				while(rs.next()) {
					originalIDsOFCurrent = rs.getString("current_trip");
					if(originalIDsOFCurrent==null) originalIDsOFCurrent ="";
				}
				//add the new info to the original 
				originalIDsOFCurrent += moveToCurrent;
				//update current trips to the new info
				ps = conn.prepareStatement("UPDATE User SET current_trip=? WHERE username=?");
				ps.setString(1, originalIDsOFCurrent);
				ps.setString(2, username);
				ps.execute();
			}
			//Now need to repeat the process for current trip:
			//either keep it, or move it to upcoming trips
			ps = conn.prepareStatement("SELECT current_trip FROM User WHERE username =?");
			ps.setString(1, username);
			rs = ps.executeQuery();
			trips = "";
			tripIds = null;
			tripDates = null;
			String moveToPending = "";
			String keepInCurrent = "";
			while(rs.next()) {
				trips = rs.getString("current_trip");
				if(trips==null) trips="";	
				tripIds = trips.split(",");
				tripDates = new String[tripIds.length];
			} if (trips.isEmpty()) {
				//no pending 
				//info_back = "{info: \"no current trips to look at\"}";
			} else {
				//need to check each trip to see if date begin is in the future->move to pending
				// if date end is in the past -> move to history
				//System.out.println("second:"+tripIds.length);
				for(int i = 0; i < tripIds.length; i++) { //adds all the info into the trip objects
					ps.close();
					rs.close();
					ps = conn.prepareStatement("SELECT Date_Begin FROM Trip WHERE TripID =?");
					ps.setString(1, tripIds[i]);
					rs = ps.executeQuery();
					rs.beforeFirst();
					rs.next();
					tripDates[i] = rs.getString("Date_Begin");
				}
				for(int i = 0; i < tripIds.length; i++) {
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
					Date dateOfTrip1 = sdf.parse(tripDates[i]);
					Calendar cal = Calendar.getInstance();
					String dateInString = "" + cal.get(Calendar.YEAR);
					dateInString += "-" + (cal.get(Calendar.MONTH)+1);
					dateInString += "-" + cal.get(Calendar.DATE);
					Date currentDate2 = sdf.parse(dateInString);
					if(dateOfTrip1.compareTo(currentDate2)>0) {
						//this trip needs to move to current trips
						moveToPending += tripIds[i]+",";
					} else {
						//this trip needs to stay
						keepInCurrent += tripIds[i]+",";
					}
				}
				//first update current trips with what needs to stay
				ps = conn.prepareStatement("UPDATE User SET current_trip=? WHERE username=?");
				ps.setString(1, keepInCurrent);
				ps.setString(2, username);
				ps.execute();
				//retrieve the info from pending trip section
				ps = conn.prepareStatement("SELECT pending_trip FROM User WHERE username=?");
				ps.setString(1, username);
				rs = ps.executeQuery();
				String originalIDsOFPending = "";
				while(rs.next()) {
					originalIDsOFPending = rs.getString("pending_trip");
					if(originalIDsOFPending==null) originalIDsOFPending ="";
				}
				//add the new info to the original 
				originalIDsOFPending += moveToPending;
				//update pending trips to the new info
				ps = conn.prepareStatement("UPDATE User SET pending_trip=? WHERE username=?");
				ps.setString(1, originalIDsOFPending);
				ps.setString(2, username);
				ps.execute();
			}
			//Final step! Need to repeat the process for current trip:
			//either keep it, or move it to past trips
			ps = conn.prepareStatement("SELECT current_trip FROM User WHERE username =?");
			ps.setString(1, username);
			rs = ps.executeQuery();
			trips = "";
			tripIds = null;
			tripDates = null;
			keepInCurrent = "";
			String moveToHistroy = "";
			
			while(rs.next()) {
				trips = rs.getString("current_trip");
				if(trips==null) trips="";	
				tripIds = trips.split(",");
				tripDates = new String[tripIds.length];
			} if (trips.isEmpty()) {
				//no pending 
				//info_back = "{info: \"no current trips to look at\"}";
			} else {
				//need to check each trip to see if date end is in the past->move to history
				//System.out.println("third:"+tripIds.length);
				for(int i = 0; i < tripIds.length; i++) { //adds all the info into the trip objects
					ps.close();
					rs.close();
					ps = conn.prepareStatement("SELECT Date_End FROM Trip WHERE TripID =?");
					ps.setString(1, tripIds[i]);
					rs = ps.executeQuery();
					rs.beforeFirst();
					rs.next();
					tripDates[i] = rs.getString("Date_End");
				}
				for(int i = 0; i < tripIds.length; i++) {
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
					Date dateOfTrip1 = sdf.parse(tripDates[i]);
					Calendar cal = Calendar.getInstance();
					String dateInString = "" + cal.get(Calendar.YEAR);
					dateInString += "-" + (cal.get(Calendar.MONTH)+1);
					dateInString += "-" + cal.get(Calendar.DATE);
					Date currentDate2 = sdf.parse(dateInString);
					if(dateOfTrip1.compareTo(currentDate2)<0) {
						//this trip needs to move to history trips
						moveToHistroy += tripIds[i]+",";
					} else {
						//this trip needs to stay
						keepInCurrent += tripIds[i]+",";
					}
				}
				//first update current trips with what needs to stay
				ps = conn.prepareStatement("UPDATE User SET current_trip=? WHERE username=?");
				ps.setString(1, keepInCurrent);
				ps.setString(2, username);
				ps.execute();
				//retrieve the info from history trip section
				ps = conn.prepareStatement("SELECT history_trip FROM User WHERE username=?");
				ps.setString(1, username);
				rs = ps.executeQuery();
				String originalIDsOFHistory = "";
				while(rs.next()) {
					originalIDsOFHistory = rs.getString("history_trip");
					if(originalIDsOFHistory==null) originalIDsOFHistory ="";
				}
				//add the new info to the original 
				originalIDsOFHistory += moveToHistroy;
				//update history trips to the new info
				ps = conn.prepareStatement("UPDATE User SET history_trip=? WHERE username=?");
				ps.setString(1, originalIDsOFHistory);
				ps.setString(2, username);
				ps.execute();
			}
			
			//System.out.println("got to the end");
        } catch (SQLException sqle){ 
        	System.out.println("sqle: " + sqle.getMessage());
		} catch (ClassNotFoundException cnfe) {
			System.out.println("cnfe: " + cnfe.getMessage());
		} catch (java.text.ParseException pe) {
			System.out.println("pe: " + pe.getMessage());
			pe.printStackTrace();
		} finally {
			try {
				if (rs != null) {rs.close();}
				if (ps != null) {ps.close();}
				if (conn != null) {conn.close();}
			}
			catch(SQLException sqle) {
				System.out.println("sql closing studd: " + sqle.getMessage());
			}
		}
        // Send info back
 		//System.out.print(info_back);
 		//PrintWriter pr = response.getWriter();
 		//pr.print(info_back);
 		//pr.close();
	}

}
