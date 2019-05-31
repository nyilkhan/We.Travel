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

@WebServlet("/friendlist")
public class friendlist extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public friendlist() {
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
		FriendListHelper information = gson.fromJson(info, FriendListHelper.class);
		
		String username = information.username;
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		PrintWriter pr = response.getWriter();
		String info_back = null;
		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://csci201-final.cmudegxvolac.us-east-2.rds.amazonaws.com/csci201?user=csci201&password=jeffereymiller");
			ps = conn.prepareStatement("SELECT * FROM User WHERE username =?");
			ps.setString(1, username);
			rs = ps.executeQuery();
			System.out.println("Success1!");
			while (rs.next())
			{
				System.out.println("Success2!");
				String friend = rs.getString("friend");
				ArrayList<String> temp = new ArrayList<String>();
				if (friend != null)
				{
					String[] temp_list = friend.split(",");
					for (int n = 0; n < temp_list.length; n++)
					{
						System.out.println("Success3!");
						System.out.println("Success!");
						ps = conn.prepareStatement("SELECT * FROM User WHERE UserID =?");
						ps.setInt(1, Integer.parseInt(temp_list[n]));
						rs = ps.executeQuery();
						while(rs.next())
						{
							temp.add(rs.getString("username"));
						}
					}
				}
				String[] back = new String[temp.size()];
				for (int n = 0; n < temp.size(); n++)
				{
					back[n] = temp.get(n);
				}
				ListReturn success = new ListReturn(back);
				String inform = gson.toJson(success);
				pr.print("[" + inform + "]");
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
				if (pr != null) {pr.close();}
			}
			catch(SQLException sqle)
			{
				System.out.println("sql closing studd: " + sqle.getMessage());
			}
		}
	}

}
