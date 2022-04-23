using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

#nullable disable

namespace DiskInventory.Models
{
    public partial class Borrower
    {
        public Borrower()
        {
            DiskBorrowLogs = new HashSet<DiskBorrowLog>();
        }

        public int BorrowerId { get; set; }
        [Required(ErrorMessage="Please Enter a First Name.")]
        public string? FirstName { get; set; }
        [Required(ErrorMessage = "Please Enter a Last Name.")]
        public string? LastName { get; set; }
        [Required(ErrorMessage = "Please Enter a Phone Number.")]
        public string? PhoneNum { get; set; }

        public virtual ICollection<DiskBorrowLog> DiskBorrowLogs { get; set; }
    }
}
