package com.ecommerce.booking.metrics;

import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.Gauge;
import io.micrometer.core.instrument.MeterRegistry;
import org.springframework.stereotype.Component;

import com.ecommerce.booking.repository.BookingRepository;

@Component
public class BookingMetrics {

    private final Counter bookingCounter;
    private final Counter bookingFailedCounter;

    public BookingMetrics(MeterRegistry registry,
                          BookingRepository repository) {

        bookingCounter = Counter.builder("booking_created_total")
                .description("Total Bookings Created")
                .register(registry);

        bookingFailedCounter = Counter.builder("booking_failed_total")
                .description("Failed Bookings")
                .register(registry);

        Gauge.builder("booking_pending_total",
                        repository,
                        repo -> repo.countByStatus("PENDING"))
                .description("Pending Bookings")
                .register(registry);

        Gauge.builder("booking_confirmed_total",
                        repository,
                        repo -> repo.countByStatus("CONFIRMED"))
                .description("Confirmed Bookings")
                .register(registry);
    }

    public void incrementBooking() {
        bookingCounter.increment();
    }

    public void incrementFailedBooking() {
        bookingFailedCounter.increment();
    }
}
