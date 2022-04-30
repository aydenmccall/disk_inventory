using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using DiskInventory.Models;
using Microsoft.EntityFrameworkCore;

namespace DiskInventory.Controllers
{
    public class BorrowLogController : Controller
    {
        private disk_inventoryamContext context;
        public BorrowLogController(disk_inventoryamContext ctx) => context = ctx;

        private BorrowLogViewModel CreateViewModel()
        {
            BorrowLogViewModel logViewModel = new BorrowLogViewModel();
            logViewModel.Disks = context.Disks.OrderBy(d => d.DiskName).ToList();
            logViewModel.Borrowers = context.Borrowers.OrderBy(b => b.LastName).ToList();
            return logViewModel;
        }
        private DiskBorrowLog ConvertFromViewToLog(BorrowLogViewModel logViewModel)
        {
            DiskBorrowLog log = new DiskBorrowLog();
            log.DiskLogId = logViewModel.DiskLogId;
            log.Disk = logViewModel.Disk;
            log.DiskId = logViewModel.DiskId.GetValueOrDefault();
            log.Borrower = logViewModel.Borrower;
            log.BorrowerId = logViewModel.BorrowerId.GetValueOrDefault();
            log.BorrowedDate = logViewModel.BorrowedDate.GetValueOrDefault();
            log.ReturnedDate = logViewModel.ReturnedDate;
            return log;
        }
        private BorrowLogViewModel ConvertFromLogToView(DiskBorrowLog log)
        {
            BorrowLogViewModel logViewModel = CreateViewModel();
            logViewModel.DiskLogId = log.DiskLogId;
            logViewModel.Disk = log.Disk;
            logViewModel.DiskId = log.DiskId;
            logViewModel.Borrower = log.Borrower;
            logViewModel.BorrowerId = log.BorrowerId;
            logViewModel.BorrowedDate = log.BorrowedDate;
            logViewModel.ReturnedDate = log.ReturnedDate;
            return logViewModel;
        }
        public IActionResult Index(string message = "")
        {
            ViewBag.message = message;
            List<DiskBorrowLog> borrowLogs = context.DiskBorrowLogs.Include(l => l.Disk).Include(l => l.Borrower).OrderBy(l => l.Disk.DiskName)
                .ThenBy(l => l.Borrower.LastName).ToList();
            return View(borrowLogs);
        }
        [HttpGet]
        public IActionResult Edit(int id)
        {
            ViewBag.Action = "Edit";
            DiskBorrowLog log = context.DiskBorrowLogs.Find(id);
            BorrowLogViewModel viewModel = ConvertFromLogToView(log);
            return View(viewModel);
        }
        [HttpPost]
        public IActionResult Edit(BorrowLogViewModel logViewModel)
        {
            DiskBorrowLog log = ConvertFromViewToLog(logViewModel);
            ViewBag.Action = "Edit";
            if (ModelState.IsValid)
            {
                context.DiskBorrowLogs.Update(log);
                context.SaveChanges();
                return RedirectToAction("Index", new { message = "Log Edited Successfully." });
            }
            return View(ConvertFromLogToView(log));
               
        }
        [HttpGet]
        public IActionResult Add()
        {
            ViewBag.Action = "Add";
            return View("Edit", CreateViewModel());
        }

        [HttpPost]
        public IActionResult Add(BorrowLogViewModel logViewModel)
        {
            ViewBag.Action = "Add";
            DiskBorrowLog log = ConvertFromViewToLog(logViewModel);
            if(ModelState.IsValid)
            {
                context.DiskBorrowLogs.Add(log);
                context.SaveChanges();
                return RedirectToAction("Index", new { message = "Log Added Successfully." });
            }
            return View("Edit", CreateViewModel());
        }
    }
}
