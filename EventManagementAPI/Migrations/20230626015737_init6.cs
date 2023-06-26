using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace EventManagementAPI.Migrations
{
    /// <inheritdoc />
    public partial class init6 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_tickets_customers_customeruid",
                table: "tickets");

            migrationBuilder.DropIndex(
                name: "IX_tickets_customeruid",
                table: "tickets");

            migrationBuilder.DropColumn(
                name: "customerIdRef",
                table: "tickets");

            migrationBuilder.DropColumn(
                name: "customeruid",
                table: "tickets");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "customerIdRef",
                table: "tickets",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "customeruid",
                table: "tickets",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateIndex(
                name: "IX_tickets_customeruid",
                table: "tickets",
                column: "customeruid");

            migrationBuilder.AddForeignKey(
                name: "FK_tickets_customers_customeruid",
                table: "tickets",
                column: "customeruid",
                principalTable: "customers",
                principalColumn: "uid",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
