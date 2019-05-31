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

@WebServlet("/PullFriendRequest")
public class PullFriendRequest extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public PullFriendRequest() {super();}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
	{
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
		PullHelper information = gson.fromJson(info, PullHelper.class);
        
        // Store in variable
        String username = information.username; 
        System.out.println(username);
        
        Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		PrintWriter pr = response.getWriter();
		String info_back = null;
		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://csci201-final.cmudegxvolac.us-east-2.rds.amazonaws.com/csci201?user=csci201&password=jeffereymiller");
			
			ps = conn.prepareStatement("SELECT * FROM FriendRequest WHERE Receiver =?");
			ps.setString(1, username);
			rs = ps.executeQuery();
			ArrayList<String> temp = new ArrayList<String>();
			while(rs.next())
			{
				String sender = rs.getString("Sender");
				temp.add(sender);
			}
			String[] FriendRequest = new String[temp.size()];
			for (int n = 0; n < temp.size(); n++)
			{
				FriendRequest[n] = temp.get(n);
			}
			info_back = gson.toJson(FriendRequest);
			PullReturnHelper PRH = null;
			if (temp.size() == 0)
			{
				PRH = new PullReturnHelper("yes", FriendRequest);
				info_back = gson.toJson(PRH);
			}
			else
			{
				PRH = new PullReturnHelper("no", FriendRequest);
				info_back = gson.toJson(PRH);
			}
			info_back = "[" + info_back + "]";
			System.out.println(info_back);
			pr.print(info_back);
			return;
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
