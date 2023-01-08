//
//  ReportVC.swift
//  BMA
//
//  Created by MACBOOK on 06/07/21.
//

import UIKit

class ReportVC: UIViewController {
    
    private var reportEventVM: ReportViewModel = ReportViewModel()
    var eventRef: String = String()

    //OUTLETS
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var reportReasonTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configUI()
    }
    
    //MARK: - configUI
    private func configUI() {
        submitBtn.sainiCornerRadius(radius: 10)
        reportReasonTextView.sainiCornerRadius(radius: 10)
        
        reportEventVM.success.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.reportEventVM.success.value {
                showAlert(STATIC_LABELS.reportPopUpHeading.rawValue, message: STATIC_LABELS.reportPopUpMsg.rawValue) {
                    // action of ok btn
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }

    //MARK: - backBtnIsPressed
    @IBAction func backBtnIsPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - submitBtnIsPressed
    @IBAction func submitBtnIsPressed(_ sender: UIButton) {
        let reason = reportReasonTextView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if reason == STATIC_LABELS.reportTextViewPlaceholder.rawValue {
            displayToast(STATIC_LABELS.emptyReportToast.rawValue)
        }
        else {
            let request = ReportRequest(eventRef: eventRef, reason: reason)
            reportEventVM.reportEvent(request: request)
        }
    }

}

//MARK: - UITextViewDelegate
extension ReportVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        reportReasonTextView.text = DocumentDefaultValues.Empty.string
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if reportReasonTextView.text == DocumentDefaultValues.Empty.string {
            reportReasonTextView.text = STATIC_LABELS.reportTextViewPlaceholder.rawValue
        }
    }
}
