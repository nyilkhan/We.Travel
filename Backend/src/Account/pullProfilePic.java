package Account;

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

@WebServlet("/pullProfilePic")
public class pullProfilePic extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public pullProfilePic() {
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
	    Gson gson = new Gson();
	    PullPicHelper information = gson.fromJson(info, PullPicHelper.class);
	    String username = information.username;
	    
	    Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String picture = null;
		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://csci201-final.cmudegxvolac.us-east-2.rds.amazonaws.com/csci201?user=csci201&password=jeffereymiller");
			ps = conn.prepareStatement("SELECT * FROM User WHERE username =?");
			ps.setString(1, username);
			rs = ps.executeQuery();
			while(rs.next())
			{
				picture = rs.getString("picture");
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
		PrintWriter pr = response.getWriter();
		pr.print("[{\"picture\": \"" + picture + "\"}]");
		//System.out.println("[\"picture\": \"" + picture + "\"]");
		pr.close();
	}

}
