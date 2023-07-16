﻿// <auto-generated />
using System;
using EventManagementAPI.Context;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;

#nullable disable

namespace EventManagementAPI.Migrations
{
    [DbContext(typeof(MySqlContext))]
    partial class MySqlContextModelSnapshot : ModelSnapshot
    {
        protected override void BuildModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "7.0.8")
                .HasAnnotation("Relational:MaxIdentifierLength", 64);

            modelBuilder.Entity("EventManagementAPI.Models.Booking", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    b.Property<int>("customerId")
                        .HasColumnType("int");

                    b.Property<int>("numberOfTickets")
                        .HasColumnType("int");

                    b.Property<int>("ticketId")
                        .HasColumnType("int");

                    b.Property<DateTime>("timeCreated")
                        .HasColumnType("datetime(6)");

                    b.HasKey("Id");

                    b.HasIndex("customerId");

                    b.HasIndex("ticketId");

                    b.ToTable("bookings");
                });

            modelBuilder.Entity("EventManagementAPI.Models.Comment", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    b.Property<string>("comment")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<DateTime>("createdTime")
                        .HasColumnType("datetime(6)");

                    b.Property<int>("customerId")
                        .HasColumnType("int");

                    b.Property<int>("dislikes")
                        .HasColumnType("int");

                    b.Property<int>("eventId")
                        .HasColumnType("int");

                    b.Property<int>("likes")
                        .HasColumnType("int");

                    b.HasKey("Id");

                    b.HasIndex("customerId");

                    b.HasIndex("eventId");

                    b.ToTable("comments");
                });

            modelBuilder.Entity("EventManagementAPI.Models.CommentDislike", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    b.Property<int>("commentId")
                        .HasColumnType("int");

                    b.Property<int>("customerId")
                        .HasColumnType("int");

                    b.HasKey("Id");

                    b.HasIndex("commentId");

                    b.HasIndex("customerId");

                    b.ToTable("commentDislikes");
                });

            modelBuilder.Entity("EventManagementAPI.Models.CommentLike", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    b.Property<int>("commentId")
                        .HasColumnType("int");

                    b.Property<int>("customerId")
                        .HasColumnType("int");

                    b.HasKey("Id");

                    b.HasIndex("commentId");

                    b.HasIndex("customerId");

                    b.ToTable("commentLikes");
                });

            modelBuilder.Entity("EventManagementAPI.Models.Event", b =>
                {
                    b.Property<int>("eventId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    b.Property<bool>("allowRefunds")
                        .HasColumnType("tinyint(1)");

                    b.Property<DateTime>("createdTime")
                        .HasColumnType("datetime(6)");

                    b.Property<string>("description")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<DateTime>("eventTime")
                        .HasColumnType("datetime(6)");

                    b.Property<int>("hosterFK")
                        .HasColumnType("int");

                    b.Property<int>("numberSaved")
                        .HasColumnType("int");

                    b.Property<bool>("privateEvent")
                        .HasColumnType("tinyint(1)");

                    b.Property<double?>("rating")
                        .HasColumnType("double");

                    b.Property<string>("tags")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<string>("title")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<string>("venue")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.HasKey("eventId");

                    b.HasIndex("hosterFK");

                    b.ToTable("events");
                });

            modelBuilder.Entity("EventManagementAPI.Models.EventSaved", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    b.Property<int>("customerId")
                        .HasColumnType("int");

                    b.Property<int>("eventId")
                        .HasColumnType("int");

                    b.HasKey("Id");

                    b.HasIndex("customerId");

                    b.HasIndex("eventId");

                    b.ToTable("eventsSaved");
                });

            modelBuilder.Entity("EventManagementAPI.Models.Reply", b =>
                {
                    b.Property<int>("id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    b.Property<int>("commentId")
                        .HasColumnType("int");

                    b.Property<int>("commenterId")
                        .HasColumnType("int");

                    b.Property<DateTime>("createdTime")
                        .HasColumnType("datetime(6)");

                    b.Property<int>("replierId")
                        .HasColumnType("int");

                    b.Property<string>("reply")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.HasKey("id");

                    b.HasIndex("commentId");

                    b.HasIndex("commenterId");

                    b.HasIndex("replierId");

                    b.ToTable("replies");
                });

            modelBuilder.Entity("EventManagementAPI.Models.Subscription", b =>
                {
                    b.Property<int>("subscriptionId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    b.Property<int>("customerIdRef")
                        .HasColumnType("int");

                    b.Property<int>("customeruid")
                        .HasColumnType("int");

                    b.Property<int>("hosterIdRef")
                        .HasColumnType("int");

                    b.Property<int>("hosteruid")
                        .HasColumnType("int");

                    b.HasKey("subscriptionId");

                    b.HasIndex("customeruid");

                    b.HasIndex("hosteruid");

                    b.ToTable("subscriptions");
                });

            modelBuilder.Entity("EventManagementAPI.Models.Ticket", b =>
                {
                    b.Property<int>("ticketId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    b.Property<DateTime>("createdTime")
                        .HasColumnType("datetime(6)");

                    b.Property<int>("eventIdRef")
                        .HasColumnType("int");

                    b.Property<string>("name")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<double>("price")
                        .HasColumnType("double");

                    b.Property<int>("toEventeventId")
                        .HasColumnType("int");

                    b.HasKey("ticketId");

                    b.HasIndex("toEventeventId");

                    b.ToTable("tickets");
                });

            modelBuilder.Entity("EventManagementAPI.Models.User", b =>
                {
                    b.Property<int>("uid")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    b.Property<string>("Discriminator")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<DateTime>("createdTime")
                        .HasColumnType("datetime(6)");

                    b.Property<string>("email")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<string>("username")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.HasKey("uid");

                    b.ToTable("User");

                    b.HasDiscriminator<string>("Discriminator").HasValue("User");

                    b.UseTphMappingStrategy();
                });

            modelBuilder.Entity("EventManagementAPI.Models.Customer", b =>
                {
                    b.HasBaseType("EventManagementAPI.Models.User");

                    b.Property<int>("loyaltyPoints")
                        .HasColumnType("int");

                    b.Property<int>("vipLevel")
                        .HasColumnType("int");

                    b.HasDiscriminator().HasValue("Customer");
                });

            modelBuilder.Entity("EventManagementAPI.Models.Hoster", b =>
                {
                    b.HasBaseType("EventManagementAPI.Models.User");

                    b.Property<string>("organisationName")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.HasDiscriminator().HasValue("Hoster");
                });

            modelBuilder.Entity("EventManagementAPI.Models.Booking", b =>
                {
                    b.HasOne("EventManagementAPI.Models.Customer", "toCustomer")
                        .WithMany()
                        .HasForeignKey("customerId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("EventManagementAPI.Models.Ticket", "toTicket")
                        .WithMany()
                        .HasForeignKey("ticketId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("toCustomer");

                    b.Navigation("toTicket");
                });

            modelBuilder.Entity("EventManagementAPI.Models.Comment", b =>
                {
                    b.HasOne("EventManagementAPI.Models.Customer", "commenter")
                        .WithMany()
                        .HasForeignKey("customerId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("EventManagementAPI.Models.Event", "eventShow")
                        .WithMany("comments")
                        .HasForeignKey("eventId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("commenter");

                    b.Navigation("eventShow");
                });

            modelBuilder.Entity("EventManagementAPI.Models.CommentDislike", b =>
                {
                    b.HasOne("EventManagementAPI.Models.Comment", "comment")
                        .WithMany()
                        .HasForeignKey("commentId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("EventManagementAPI.Models.Customer", "customer")
                        .WithMany()
                        .HasForeignKey("customerId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("comment");

                    b.Navigation("customer");
                });

            modelBuilder.Entity("EventManagementAPI.Models.CommentLike", b =>
                {
                    b.HasOne("EventManagementAPI.Models.Comment", "comment")
                        .WithMany()
                        .HasForeignKey("commentId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("EventManagementAPI.Models.Customer", "customer")
                        .WithMany()
                        .HasForeignKey("customerId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("comment");

                    b.Navigation("customer");
                });

            modelBuilder.Entity("EventManagementAPI.Models.Event", b =>
                {
                    b.HasOne("EventManagementAPI.Models.Hoster", "host")
                        .WithMany("events")
                        .HasForeignKey("hosterFK")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("host");
                });

            modelBuilder.Entity("EventManagementAPI.Models.EventSaved", b =>
                {
                    b.HasOne("EventManagementAPI.Models.Customer", "customer")
                        .WithMany()
                        .HasForeignKey("customerId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("EventManagementAPI.Models.Event", "eventShow")
                        .WithMany()
                        .HasForeignKey("eventId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("customer");

                    b.Navigation("eventShow");
                });

            modelBuilder.Entity("EventManagementAPI.Models.Reply", b =>
                {
                    b.HasOne("EventManagementAPI.Models.Comment", "comment")
                        .WithMany("replies")
                        .HasForeignKey("commentId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("EventManagementAPI.Models.User", "commenter")
                        .WithMany()
                        .HasForeignKey("commenterId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("EventManagementAPI.Models.User", "replier")
                        .WithMany()
                        .HasForeignKey("replierId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("comment");

                    b.Navigation("commenter");

                    b.Navigation("replier");
                });

            modelBuilder.Entity("EventManagementAPI.Models.Subscription", b =>
                {
                    b.HasOne("EventManagementAPI.Models.Customer", "customer")
                        .WithMany()
                        .HasForeignKey("customeruid")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("EventManagementAPI.Models.Hoster", "hoster")
                        .WithMany()
                        .HasForeignKey("hosteruid")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("customer");

                    b.Navigation("hoster");
                });

            modelBuilder.Entity("EventManagementAPI.Models.Ticket", b =>
                {
                    b.HasOne("EventManagementAPI.Models.Event", "toEvent")
                        .WithMany()
                        .HasForeignKey("toEventeventId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("toEvent");
                });

            modelBuilder.Entity("EventManagementAPI.Models.Comment", b =>
                {
                    b.Navigation("replies");
                });

            modelBuilder.Entity("EventManagementAPI.Models.Event", b =>
                {
                    b.Navigation("comments");
                });

            modelBuilder.Entity("EventManagementAPI.Models.Hoster", b =>
                {
                    b.Navigation("events");
                });
#pragma warning restore 612, 618
        }
    }
}
