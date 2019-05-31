package Restaurant;

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


@WebServlet("/restaurantDB")
public class restaurantDB extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public restaurantDB() {
        super();
        
    }




	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		StringBuilder sb = new StringBuilder();
		BufferedReader br = request.getReader();
		try {
			String line = "";
			while((line = br.readLine()) != null) {
				sb.append(line).append('\n');
			}
		}finally {
			br.close();
		}
		String info = sb.toString();
		Gson gson = new Gson();
		restaurantInfo RI = gson.fromJson(info, restaurantInfo.class);
		
		String name = RI.name;
		String price = RI.price;
		String rating = RI.rating;
		String image = RI.image;
		String url = RI.url;
		String address = RI.address;
		
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		PrintWriter pr = response.getWriter();
		String info_back = null;
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://csci201-final.cmudegxvolac.us-east-2.rds.amazonaws.com/csci201?user=csci201&password=jeffereymiller");
			ps = conn.prepareStatement("INSERT INTO Restaurant(name,address,rating,price,image,link) VALUES (?,?,?,?,?,?)");
			ps.setString(1, name);
			ps.setString(2, address);
			ps.setString(3, rating);
			ps.setString(4, price);
			ps.setString(5, image);
			ps.setString(6, url);
			ps.execute();
			info_back = "{info: \"Restaurant added to database\"}";
			pr.print(info_back);
			ps.close();
			
			
		}catch (SQLException sqle) {
			System.out.println("sqle: " + sqle.getMessage());
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
	}

}
