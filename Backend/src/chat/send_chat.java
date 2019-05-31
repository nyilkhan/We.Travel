package chat;

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

@WebServlet("/send_chat")
public class send_chat extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
   
    public send_chat() {
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
	    message information = gson.fromJson(info, message.class);
        
        // Store in variable
        String sender = information.Sender; 
        String reciever = information.Receiver; 
        String body = information.Body;
        String date = information.Date;
        
        System.out.println("date: " + date);
       
        
        // info_back
        String info_back = null;
        
        // Contact database
        Connection conn = null;
		PreparedStatement ps = null;
		int rs = 0;
		 
		PreparedStatement ps2 = null;
		int rs2;
		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://csci201-final.cmudegxvolac.us-east-2.rds.amazonaws.com/csci201?user=csci201&password=jeffereymiller");
			ps = conn.prepareStatement("INSERT INTO Chat(Sender,Receiver,Date,Body) VALUES (?,?,?,?)");

			ps.setString(1, sender);
			ps.setString(2, reciever);
			ps.setString(3, date);
			ps.setString(4, body);
			rs = ps.executeUpdate();
			
		
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
	}
}
