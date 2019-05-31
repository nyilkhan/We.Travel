package Trip;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
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

import com.google.gson.Gson;

@WebServlet("/deleteTrip")
public class deleteTrip extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
   
    public deleteTrip() {
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
	    System.out.println("info is: " + info);
	    
	    // Parse JSON String
	    // json = "{\"username\":\"Peter\", \"tripid\": 123}";

	    Gson gson = new Gson();
	    userdelete information = gson.fromJson(info, userdelete.class);
        
        // Store in variable
        String username = information.username; 
        String tripID = information.TripID;
        
        // info_back
        String info_back = null;
        
        // Contact database
        Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		PreparedStatement ps2 = null;
		int rs2 = 0;
		PreparedStatement ps3 = null;
		int rs3 = 0;
		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://csci201-final.cmudegxvolac.us-east-2.rds.amazonaws.com/csci201?user=csci201&password=jeffereymiller");
			ps = conn.prepareStatement("SELECT * FROM User WHERE username =?");
			ps.setString(1, username);
			System.out.println("ps: " + ps);
			rs = ps.executeQuery();
			while (rs.next())
			{
				String trips = "";
				String[] tripIds = null;
				trips = rs.getString("current_trip");
				System.out.println("trips: " + trips);
				tripIds = trips.split(",");
				Boolean did_delete = false;
				for(int i = 0; i < tripIds.length; i++)
				{
					System.out.println("tripID: " + tripID + " checking: " + tripIds[i]);
					if(tripIds[i].equals(tripID)) {
//						ps2 = conn.prepareStatement("DELETE FROM Trip WHERE TripID =?");
//						ps2.setInt(1, Integer.parseInt(tripID));
//						rs2 = ps2.executeUpdate();
						
						String new_trip_string = "";
						if (tripIds.length == 1)
						{
							new_trip_string = null;
						}
						else
						{
							for (int g = 0; g < tripIds.length; g++)
							{
								if (tripIds[g] != tripIds[i])
								{
									new_trip_string += tripIds[g];
									new_trip_string += ",";
								}
							}
							new_trip_string = new_trip_string.substring(0, new_trip_string.length() - 1);
						}
						
						System.out.println("new_trip_string: " + new_trip_string);
						ps3 = conn.prepareStatement("UPDATE User SET current_trip=? WHERE username =?");
						ps3.setString(1, new_trip_string);
						ps3.setString(2, username);
						rs3 = ps3.executeUpdate();
						did_delete = true;
						break;
					}
				}
				PrintWriter pr = response.getWriter();
				if (did_delete)
				{
					pr.print("Did delete");
				}
				else
				{
					pr.print("User doesn't match with trip");
				}
				pr.close();
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
				if (rs != null) {rs.close();}
				if (ps2 != null) {ps.close();}
				if (ps3 != null) {ps.close();}
				if (conn != null) {conn.close();}
			}
			catch(SQLException sqle)
			{
				System.out.println("sql closing studd: " + sqle.getMessage());
			}
		}
		
		// Send info back
		
		System.out.print(info_back);
		PrintWriter pr = response.getWriter();
		pr.print(info_back);
		pr.close();
	}
}
