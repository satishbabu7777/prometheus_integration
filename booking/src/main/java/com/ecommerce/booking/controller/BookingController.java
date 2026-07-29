package com.ecommerce.booking.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.ecommerce.booking.entity.Booking;
import com.ecommerce.booking.service.BookingServiceImpl;

@RestController
@RequestMapping("/bookings")
public class BookingController {

    private final BookingServiceImpl bookingService;

    public BookingController(BookingServiceImpl bookingService) {
        this.bookingService = bookingService;
    }

    @PostMapping
    public Booking createBooking(@RequestParam Long userId,
                                 @RequestParam Long flightId) {

        return bookingService.createBooking(userId, flightId);
    }

    @GetMapping("/{name}")
    public String testApi(@PathVariable String name) {
        return name + " booking service is working fine";
    }

}
