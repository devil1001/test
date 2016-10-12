package rest;

import javax.ws.rs.ApplicationPath;
import javax.ws.rs.core.Application;
import java.util.HashSet;
import java.util.Set;

/**
 * Created by devil1001 on 12.10.16.
 */
@ApplicationPath("db/api")
public class RestApplication extends Application {
    @Override
    public Set<Object> getSingletons() {
        final HashSet<Object> objects = new HashSet<>();
        objects.add(new Forum());
        objects.add(new Post());
        objects.add(new User());
        objects.add(new Thread());
        return objects;
    }
}
