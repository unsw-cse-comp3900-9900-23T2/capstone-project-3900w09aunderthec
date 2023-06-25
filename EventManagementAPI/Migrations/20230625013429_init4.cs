using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace EventManagementAPI.Migrations
{
    /// <inheritdoc />
    public partial class init4 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_events_hosts_hostuid",
                table: "events");

            migrationBuilder.DropIndex(
                name: "IX_events_hostuid",
                table: "events");

            migrationBuilder.DropColumn(
                name: "hostIdRef",
                table: "events");

            migrationBuilder.DropColumn(
                name: "hostuid",
                table: "events");

            migrationBuilder.AddColumn<int>(
                name: "Hosteruid",
                table: "events",
                type: "int",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_events_Hosteruid",
                table: "events",
                column: "Hosteruid");

            migrationBuilder.AddForeignKey(
                name: "FK_events_hosts_Hosteruid",
                table: "events",
                column: "Hosteruid",
                principalTable: "hosts",
                principalColumn: "uid");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_events_hosts_Hosteruid",
                table: "events");

            migrationBuilder.DropIndex(
                name: "IX_events_Hosteruid",
                table: "events");

            migrationBuilder.DropColumn(
                name: "Hosteruid",
                table: "events");

            migrationBuilder.AddColumn<int>(
                name: "hostIdRef",
                table: "events",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "hostuid",
                table: "events",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateIndex(
                name: "IX_events_hostuid",
                table: "events",
                column: "hostuid");

            migrationBuilder.AddForeignKey(
                name: "FK_events_hosts_hostuid",
                table: "events",
                column: "hostuid",
                principalTable: "hosts",
                principalColumn: "uid",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
