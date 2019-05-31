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

@WebServlet("/update_pic")
public class update_pic extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public update_pic() {
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
	    //System.out.println("info is: " + info);
	    Gson gson = new Gson();
	    pichelper information = gson.fromJson(info, pichelper.class);
        
        // Store in variable
        String username = information.username; 
        String picture = information.picture;
        
        Connection conn = null;
		PreparedStatement ps = null;
		int rs = 0;
		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://csci201-final.cmudegxvolac.us-east-2.rds.amazonaws.com/csci201?user=csci201&password=jeffereymiller");
			ps = conn.prepareStatement("UPDATE User set picture = ? WHERE username = ?");
			ps.setString(1, picture);
			ps.setString(2, username);
			rs = ps.executeUpdate();
			//String correct_password = null;
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
		pr.print("Add_picture");
		pr.close();
	}

}
