package YelpEvents;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;



/**
 * Servlet implementation class YelpEventsCall
 */
@WebServlet("/YelpEventsCall")
public class YelpEventsCall extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

    public YelpEventsCall() {
        super();
        // TODO Auto-generated constructor stub
    }


	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		StringBuilder sb = new StringBuilder();
		BufferedReader br = request.getReader();
		String ll;
		try {
			String line = "";
			ll = br.readLine();
			/*while((line = br.readLine()) != null) {
				sb.append(line).append('\n');
			}*/
		}finally {
			br.close();
		}
		//String info = sb.toString();
		System.out.println("ll:" + ll);
		String[] allInfo = ll.split("[|]");
		
		
		///////////////////////
		//These will be replaced by request parameters that you can pass from swift
		String term = allInfo[0];
		String city;
		double lat = 0.00;
		double lon = 0.00;
		if(allInfo[1].isEmpty()) {
			city = null;
		}
		else {
			city = allInfo[1];
		}
		if(!allInfo[2].equals("nil")) {
			System.out.println("Triggered");
			lat = Double.parseDouble(allInfo[2]);
			lon = Double.parseDouble(allInfo[2]);
		}
		
		PrintWriter pw = response.getWriter();
		
		YelpEventsResponse res = new YelpEventsResponse();
		res.searchResults(term,city,lat,lon);
		List<Event> list1 = res.results.getEvents();
		
		JSONObject[] jArr = new JSONObject[5];
		//sends over a json for each of the 5 restaurants
		for(int i = 0;i < list1.size(); i++) {
			JSONObject temp = res.createString(list1.get(i));
			jArr[i] = temp;
			pw.print(temp);
		}
		//System.out.println(jArr);
		//pw.print(jArr);
		pw.close();
	}

}
