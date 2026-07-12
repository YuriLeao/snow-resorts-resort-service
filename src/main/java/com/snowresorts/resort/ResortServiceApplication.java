package com.snowresorts.resort;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.ConfigurationPropertiesScan;

@SpringBootApplication
@ConfigurationPropertiesScan
public class ResortServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(ResortServiceApplication.class, args);
    }
}
