using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace DiskInventory.Models
{
    public class BorrowLogViewModel
    {
        //public int DiskLogId { get; set; }                                      // VIRTUAL REFERENCE IS BETTER :)
        //[Required(ErrorMessage = "Please Select a Disk.")]
        //public int? DiskId { get; set; }
        //[Required(ErrorMessage = "Please Select a Borrower.")]
        //public int? BorrowerId { get; set; }
        //[Required(ErrorMessage ="Please Enter The Date The Product was Borrowed.")]
        //public DateTime? BorrowedDate { get; set; }
        //public DateTime? ReturnedDate { get; set; }
        public BorrowLogViewModel()
        {
            Log = new DiskBorrowLog();
        }

        public virtual DiskBorrowLog Log { get; set;}
        public virtual Borrower Borrower { get; set; }
        public virtual Disk Disk { get; set; }

        public List<Borrower> Borrowers { get; set; }
        public List<Disk> Disks { get; set; }
    }
}
