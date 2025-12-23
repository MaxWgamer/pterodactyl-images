# Pterodactyl Images

Production-ready Docker images for Pterodactyl Panel, originally created for [FreshPerf](https://freshperf.fr) hosting services. Primarily designed for Minecraft servers with optimal performance and reliability. Compatible with any Java application.

## Available Images

### Eclipse Temurin (Adoptium)

- **Java 8**: `ghcr.io/maxwgamer/pterodactyl-images:java_8`
- **Java 11**: `ghcr.io/maxwgamer/pterodactyl-images:java_11`
- **Java 16**: `ghcr.io/maxwgamer/pterodactyl-images:java_16`
- **Java 17**: `ghcr.io/maxwgamer/pterodactyl-images:java_17`
- **Java 21**: `ghcr.io/maxwgamer/pterodactyl-images:java_21`
- **Java 25**: `ghcr.io/maxwgamer/pterodactyl-images:java_25`

### IBM Semeru (OpenJ9)

- **Java 21 (J9)**: `ghcr.io/maxwgamer/pterodactyl-images:java_21j9`

## Why These Images?

### Key Improvements Over Default Pterodactyl Images

#### 🔧 **Production-Ready Dockerfiles**
These images provide essential production improvements:

- **JRE-only images**: Uses lightweight JRE (not JDK) to reduce image size and attack surface
- **Minimal dependencies**: Only essential packages included - no recommended dependencies installed for smaller, faster images
- **Proper init process**: Uses `tini` as PID 1 to handle signals correctly and prevent zombie processes
- **Clean shutdown**: `STOPSIGNAL SIGINT` ensures graceful server shutdown instead of forceful termination
- **Locale configuration**: UTF-8 properly configured for consistent string handling

#### 🧠 **Automatic Memory Management**
The entrypoint automatically configures Java heap memory allocation, solving the critical Linux Kernel 6.12+ cgroup v2 detection bug that causes OOM kills.

**Problem solved**: Modern kernels (6.12+) break Java's automatic memory detection in containers, causing crashes. These images handle this automatically.

**How it works**:
- When Pterodactyl sets `SERVER_MEMORY` (e.g., 4096 MB), the entrypoint calculates 90% for Java heap and exports it as `JAVA_ARGS="-Xmx3686M"`
- For unlimited memory containers, uses `JAVA_ARGS="-XX:MaxRAMPercentage=90.0"`
- The `JAVA_ARGS` variable is automatically available in your startup command

**Example usage in your startup command**:
```bash
java ${JAVA_ARGS} -jar server.jar
```
This will expand to: `java -Xmx3686M -jar server.jar` (if SERVER_MEMORY=4096)

**You can also combine with additional flags**:
```bash
java ${JAVA_ARGS} -XX:+UseStringDeduplication -jar paper.jar
```

## Usage

### In Pterodactyl Panel

1. Navigate to **Admin Area** → **Nests** → **Minecraft**
2. Select your egg (e.g., "Paper")
3. In **Docker Images**, add the appropriate image:
   ```
   Java 25: ghcr.io/maxwgamer/pterodactyl-images:java_25
   Java 21: ghcr.io/maxwgamer/pterodactyl-images:java_21
   ```

## Acknowledgments

Projects used or code based on:

- [ptero-eggs/yolks](https://github.com/Ptero-Eggs/yolks)
- [trenutoo/pterodactyl-images](https://github.com/trenutoo/pterodactyl-images)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

