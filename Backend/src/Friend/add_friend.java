package Friend;


import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

/**
 * Servlet implementation class add_friend
 */
@WebServlet("/add_friend")
public class add_friend extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public add_friend() {
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
		Gson gson = new Gson();
	    add_helper infom = gson.fromJson(info, add_helper.class);
        
        // Store in variable
        String username = infom.find_friend; 
        String sender = infom.sender;
        
        System.out.println(username);
        System.out.println(sender);
        
        Connection conn = null;
		PreparedStatement ps = null;
		PreparedStatement ps1 = null;
		PreparedStatement ps2 = null;
		PreparedStatement ps3 = null;
		
		//PreparedStatement ps4 = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		int rs2;
		int rs3;
		ResultSet rs4 = null;
		PrintWriter pr = response.getWriter();
		String info_back = null;
		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://csci201-final.cmudegxvolac.us-east-2.rds.amazonaws.com/csci201?user=csci201&password=jeffereymiller");
			// Getting the userid of friend to be added
			ps = conn.prepareStatement("SELECT * FROM User WHERE username =?");
			ps.setString(1, username);
			//System.out.println(username);
			rs = ps.executeQuery();
			Boolean test = true;
			while(rs.next())
			{
				// Getting the original friend string
				int id = rs.getInt("userID");
				ps1 = conn.prepareStatement("SELECT * FROM User WHERE username =?");
				ps1.setString(1, sender);
				rs1 = ps1.executeQuery();
				// Add new friend to the string and update
				while(rs1.next())
				{
					String old_friend = rs1.getString("friend");
					Boolean exist = false;
					if (old_friend != null)
					{
						String[] temp = old_friend.split(",");
						for (int n = 0; n < temp.length; n++)
						{
							if (temp[n].equals(Integer.toString(id)))
							{
								exist = true;
								break;
							}
						}
					}
					if (exist)
					{
						info_back = "{\"info\": \"Friend Request Sent!\"}";
						pr.print(info_back);
						return;
					}
					int ToBeAddedUserId = rs1.getInt("userID");
					String new_friend = null;
					if (old_friend == null)
					{
						new_friend = Integer.toString(id);
					}
					else
					{
						if (old_friend.isEmpty())
						{
							new_friend = Integer.toString(id);
						}
						new_friend = old_friend + "," + Integer.toString(id);
					}
					ps2 = conn.prepareStatement("UPDATE User SET friend =? WHERE userID =?");
					ps2.setString(1, new_friend);
					ps2.setInt(2, ToBeAddedUserId);
					rs2 = ps2.executeUpdate();
					// Insert into add friend request database
					Boolean Test = false;
					ps3 = conn.prepareStatement("SELECT * FROM FriendRequest WHERE Receiver =? AND Sender =?");
					ps3.setString(1, username);
					ps3.setString(2, sender);
					rs4 = ps3.executeQuery();
					while (rs4.next())
					{
						Test = true;
					}
					
					if (!Test)
					{
						ps3 = conn.prepareStatement("INSERT INTO FriendRequest(Sender, Receiver) VALUES (?,?)");
						ps3.setString(1, sender);
						ps3.setString(2, username);
						rs3 = ps3.executeUpdate();
					}
				}
				test = false;
				info_back = "{\"info\": \"Friend Request Sent!\"}";
				pr.print(info_back);
				return;
			}
			if (test) // Username doesn't exist
			{
				info_back = "{\"info\": \"Username doesn't exist!\"}";
				pr.print(info_back);
				return;
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
				if (rs1 != null) {rs.close();}
				//if (rs2 != null) {rs.close();}
				//if (rs3 != null) {rs.close();}
				if (ps != null) {ps.close();}
				if (ps1 != null) {ps.close();}
				if (ps2 != null) {ps.close();}
				if (ps3 != null) {ps.close();}
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
