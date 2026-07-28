package com.ecommerce.booking.metrics;

import org.springframework.stereotype.Component;

import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;

@Component
public class SearchMetrics {

    private final Counter searchCounter;

    public SearchMetrics(MeterRegistry registry) {

        searchCounter = Counter.builder("flight_search_total")
                .description("Flight Searches")
                .register(registry);
    }

    public void increment() {
        searchCounter.increment();
    }

}
