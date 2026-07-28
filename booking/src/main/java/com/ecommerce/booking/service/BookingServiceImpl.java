package com.ecommerce.booking.service;

import io.micrometer.core.instrument.MeterRegistry;
import io.micrometer.core.instrument.Timer;
import org.springframework.stereotype.Service;

import com.ecommerce.booking.entity.Booking;
import com.ecommerce.booking.metrics.BookingMetrics;
import com.ecommerce.booking.repository.BookingRepository;

@Service
public class BookingServiceImpl {

    private final BookingRepository repository;
    private final BookingMetrics metrics;
    private final MeterRegistry registry;

    public BookingServiceImpl(BookingRepository repository,
                              BookingMetrics metrics,
                              MeterRegistry registry) {

        this.repository = repository;
        this.metrics = metrics;
        this.registry = registry;
    }

    public Booking createBooking(Long userId,
                                 Long flightId) {

        Timer.Sample sample = Timer.start(registry);

        try {

            Booking booking = new Booking();

            booking.setUserId(userId);
            booking.setFlightId(flightId);
            booking.setStatus("CONFIRMED");

            repository.save(booking);

            metrics.incrementBooking();

            return booking;

        } catch (Exception ex) {

            metrics.incrementFailedBooking();

            throw ex;

        } finally {

            sample.stop(
                    Timer.builder("booking_execution_time")
                            .description("Booking API execution time")
                            .register(registry));
        }
    }
}
