package rest;

import org.json.JSONObject;

import javax.inject.Singleton;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.Map;

/**
 * Created by devil1001 on 12.10.16.
 */


@Singleton
@Path("/forum")
public class Forum {

    @POST
    @Path("create")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response create(final String input, @Context HttpServletRequest request) {
        JSONObject jsonResult = new JSONObject();

        JSONObject jsonObject = new JSONObject(input);
        return Response.status(Response.Status.OK).entity(jsonResult.toString()).build();
    }

    @GET
    @Path("details")
    @Produces(MediaType.APPLICATION_JSON)
    public Response details(@Context HttpServletRequest request) {
        Map<String, String[]> params = request.getParameterMap();
        JSONObject jsonResult = new JSONObject();

        return Response.status(Response.Status.OK).entity(jsonResult.toString()).build();
    }

    @GET
    @Path("listPosts")
    @Produces(MediaType.APPLICATION_JSON)
    public Response listPosts(@Context HttpServletRequest request) {
        Map<String, String[]> params = request.getParameterMap();
        JSONObject jsonResult = new JSONObject();

        return Response.status(Response.Status.OK).entity(jsonResult.toString()).build();
    }

    @GET
    @Path("listThreads")
    @Produces(MediaType.APPLICATION_JSON)
    public Response listThreads(@Context HttpServletRequest request) {
        Map<String, String[]> params = request.getParameterMap();
        JSONObject jsonResult = new JSONObject();

        return Response.status(Response.Status.OK).entity(jsonResult.toString()).build();
    }

    @GET
    @Path("listUsers")
    @Produces(MediaType.APPLICATION_JSON)
    public Response listUsers(@Context HttpServletRequest request) {
        Map<String, String[]> params = request.getParameterMap();
        JSONObject jsonResult = new JSONObject();

        return Response.status(Response.Status.OK).entity(jsonResult.toString()).build();
    }
}