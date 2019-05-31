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

@WebServlet("/verify_password")
public class verify_password extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
   
    public verify_password() {
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
	    // json = "{\"username\":\"Peter\", \"password\": 123}";

	    Gson gson = new Gson();
	    userInfo information = gson.fromJson(info, userInfo.class);
        
        // Store in variable
        String username = information.username; 
        String password = information.password;
        
        System.out.println(username);
        System.out.println(password);
        
        // info_back
        String info_back = null;
        
        // Contact database
        Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://csci201-final.cmudegxvolac.us-east-2.rds.amazonaws.com/csci201?user=csci201&password=jeffereymiller");
			ps = conn.prepareStatement("SELECT * FROM User WHERE username =?");
			ps.setString(1, username);
			rs = ps.executeQuery();
			String correct_password = null;
			while(rs.next())
			{
				correct_password = rs.getString("password");
				System.out.println("my_password: " + password);
				System.out.println("correct_password: " + correct_password);
			}
			if (correct_password == null)
			{
				info_back = "[{\"info\": \"username doesn't exist\"}]";
			}
			else if (!correct_password.equals(password))
			{
				info_back = "[{\"info\": \"wrong password\"}]";
			}
			else
			{
				info_back = "[{\"info\": \"login success\"}]";
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
		System.out.print(info_back);
		PrintWriter pr = response.getWriter();
		pr.print(info_back);
		pr.close();
	}
}
