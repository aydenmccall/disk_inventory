using System;
using System.Collections.Generic;

#nullable disable

namespace DiskInventory.Models
{
    public partial class ViewBorrowerNoLoan
    {
        public int BorrowerId { get; set; }
        public string LastName { get; set; }
        public string FirstName { get; set; }
    }
}
