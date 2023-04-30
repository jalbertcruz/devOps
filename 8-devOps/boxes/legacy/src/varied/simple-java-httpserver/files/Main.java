import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpServer;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;

public class Main {

    // https://stackoverflow.com/questions/3732109/simple-http-server-in-java-using-only-java-se-api
    public static void main(String[] args) throws Exception {
        // javac Main.java
        // java Main 8000
        // http :8000/path
        HttpServer server = HttpServer.create(new InetSocketAddress(Integer.parseInt(args[0])), 0);
        server.createContext("/path", new MyHandler());
        server.setExecutor(null); // creates a default executor
        server.start();
    }

    static class MyHandler implements HttpHandler {
        @Override
        public void handle(HttpExchange t) throws IOException {
            String response = "This is the response";
            t.sendResponseHeaders(200, response.length());
            OutputStream os = t.getResponseBody();
            os.write(response.getBytes());
            os.close();
        }
    }

}
