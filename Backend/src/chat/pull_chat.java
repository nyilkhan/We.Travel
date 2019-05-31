package chat;

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

@WebServlet("/pull_chat")
public class pull_chat extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public pull_chat() {
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
	    //System.out.println(info);

	    Gson gson = new Gson();
	    PullChatHelper information = gson.fromJson(info, PullChatHelper.class);
        
        // Store in variable
        String LoggedInUser = information.LoggedInUser; 
        String Aim = information.Aim;
        
        // info_back
        String info_back = null;
        
        // Contact database
        Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		ArrayList<message> temp = new ArrayList<message>();
		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://csci201-final.cmudegxvolac.us-east-2.rds.amazonaws.com/csci201?user=csci201&password=jeffereymiller");
			ps = conn.prepareStatement("SELECT * FROM Chat WHERE (Sender =? AND Receiver=?) OR (Sender=? AND Receiver=?)");
			ps.setString(1, LoggedInUser);
			ps.setString(2, Aim);
			ps.setString(3, Aim);
			ps.setString(4, LoggedInUser);
			rs = ps.executeQuery();
			while(rs.next())
			{
				message new_message = new message(rs.getString("Sender"), rs.getString("Receiver"), rs.getString("Body"), rs.getString("Date"));
				temp.add(new_message);
			}
			PullChatHelper2 lalala = new PullChatHelper2(temp.size());
			for (int n = 0; n < temp.size(); n++)
			{
				//String temporary = "\"Receiver:\"" + temp.get(n).GetReceiver() + ", \"Sender:\"" + temp.get(n).GetSender() + ", \"Date:\"" + temp.get(n).GetDate() + ", \"Body:\"" + temp.get(n).GetBody();
				lalala.chats[n] = temp.get(n);
			}
			info_back = gson.toJson(lalala);
			// Send info back
			System.out.println(info_back);
			PrintWriter pr = response.getWriter();
			pr.print(info_back);
//			pr.close();
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
	}
}