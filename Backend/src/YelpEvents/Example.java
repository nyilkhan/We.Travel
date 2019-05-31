package YelpEvents;

import java.util.List;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class Example {

@SerializedName("events")
@Expose
private List<Event> events = null;
@SerializedName("total")
@Expose
private Integer total;

public List<Event> getEvents() {
return events;
}

public void setEvents(List<Event> events) {
this.events = events;
}

public Integer getTotal() {
return total;
}

public void setTotal(Integer total) {
this.total = total;
}

}