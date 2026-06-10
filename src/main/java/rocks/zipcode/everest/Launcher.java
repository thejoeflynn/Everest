package rocks.zipcode.everest;

/**
 * Wrapper launcher to bypass JavaFX's module presence check when running
 * from a shaded JAR where JavaFX is on the classpath rather than module path.
 */
public class Launcher {
    public static void main(String[] args) {
        Main.main(args);
    }
}
