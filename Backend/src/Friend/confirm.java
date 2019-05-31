package Friend;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

@WebServlet("/confirm")
public class confirm extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public confirm() {
        super();
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
		Gson gson = new Gson();
		confirm_helper information = gson.fromJson(info, confirm_helper.class);
        
        // Store in variable
        String username = information.username; //Peter
        String from_who = information.from_who; //Zhu Shen
        
        System.out.println("from_who: " + from_who);
        System.out.println("username: " + username);
        //System.out.println(username);
        
        Connection conn = null;
		PreparedStatement ps = null;
		PreparedStatement ps1 = null;
		PreparedStatement ps2 = null;
		PreparedStatement ps3 = null;
		ResultSet rs1 = null;
		ResultSet rs2 = null;
		int rs3;
		int rs;
		PrintWriter pr = response.getWriter();
		String info_back = null;
		try
		{
			// Delete request
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://csci201-final.cmudegxvolac.us-east-2.rds.amazonaws.com/csci201?user=csci201&password=jeffereymiller");
			ps = conn.prepareStatement("DELETE FROM FriendRequest WHERE Receiver =? AND Sender =?");
			ps.setString(1, username);
			ps.setString(2, from_who);
			rs = ps.executeUpdate();
			//ArrayList<String> temp = new ArrayList<String>();
			
			// Add Friend
			ps2 = conn.prepareStatement("SELECT * FROM User WHERE username =?");
			ps2.setString(1, username);
			rs2 = ps2.executeQuery();
			int id = 0;
			String new_friend = null;
			String friend = null;
			int id_add = 0;
			while (rs2.next())
			{
				friend = rs2.getString("friend");
				id = rs2.getInt("userID");
			}
			
			ps1 = conn.prepareStatement("SELECT * FROM User WHERE username =?");
			ps1.setString(1, from_who);
			rs1 = ps1.executeQuery();
			while (rs1.next())
			{
				id_add = rs1.getInt("UserID");
			}
			
			if (friend == null)
			{
				new_friend = Integer.toString(id_add);
			}
			else
			{
				if (friend.isEmpty())
				{
					new_friend = Integer.toString(id_add);
				}
				new_friend = friend + "," + Integer.toString(id_add);
			}
			
			//System.out.println("new_friend: " + new_friend);
			ps3 = conn.prepareStatement("UPDATE User SET friend =? WHERE userID =?");
			ps3.setString(1, new_friend);
			ps3.setInt(2, id);
			rs3 = ps3.executeUpdate();
//			info_back = "{\"info\": \"Accepted Request!\"}";
//			pr.print(info_back);
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
				if (rs1 != null) {rs1.close();}
				if (rs2 != null) {rs2.close();}
				if (ps != null) {ps.close();}
				if (ps1 != null) {ps1.close();}
				if (ps2 != null) {ps2.close();}
				if (ps3 != null) {ps3.close();}
				if (conn != null) {conn.close();}
				if (pr != null) {pr.close();}
			}
			catch(SQLException sqle)
			{
				System.out.println("sql closing studd: " + sqle.getMessage());
			}
		}
	}

}
