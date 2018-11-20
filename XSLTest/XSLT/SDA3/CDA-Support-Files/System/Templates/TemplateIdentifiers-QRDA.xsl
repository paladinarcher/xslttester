<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0">

	<!-- QRDA Document Templates -->
	<xsl:variable name="qrda-Category1">2.16.840.1.113883.10.20.24.1.1</xsl:variable>
	<xsl:variable name="qrda-QualityDataModelBased">2.16.840.1.113883.10.20.24.1.2</xsl:variable>

	<!-- QRDA Section Templates -->
	<xsl:variable name="qrda-MeasureSection">2.16.840.1.113883.10.20.24.2.2</xsl:variable>
	<xsl:variable name="qrda-QualityDataModelBasedMeasureSection">2.16.840.1.113883.10.20.24.2.3</xsl:variable>
	<xsl:variable name="qrda-ReportingParametersSection">2.16.840.1.113883.10.20.17.2.1</xsl:variable>
	<xsl:variable name="qrda-PatientDataSection">2.16.840.1.113883.10.20.17.2.4</xsl:variable>
	<xsl:variable name="qrda-QualityDataModelBasedPatientDataSection">2.16.840.1.113883.10.20.24.2.1</xsl:variable>

	<!-- C-CDA Clinical Statement and Supporting Templates -->
	<xsl:variable name="qrda-MeasureReference">2.16.840.1.113883.10.20.24.3.98</xsl:variable>
	<xsl:variable name="qrda-QualityDataModelBasedMeasureReference">2.16.840.1.113883.10.20.24.3.97</xsl:variable>
	<xsl:variable name="qrda-ReportingParametersAct">2.16.840.1.113883.10.20.17.3.8</xsl:variable>
	
	<!-- QRDA Entry Templates -->
	<xsl:variable name="qrda-ActIntoleranceOrAdverseEventObservation">2.16.840.1.113883.10.20.24.3.104</xsl:variable>
	<xsl:variable name="qrda-AgeObservation">2.16.840.1.113883.10.20.22.4.31</xsl:variable>
	<xsl:variable name="qrda-AssessmentScaleReportingObservation">2.16.840.1.113883.10.20.22.4.86</xsl:variable>
	<xsl:variable name="qrda-CareGoal">2.16.840.1.113883.10.20.24.3.1</xsl:variable>
	<xsl:variable name="qrda-CaregiverCharacteristics">2.16.840.1.113883.10.20.22.4.72</xsl:variable>
	<xsl:variable name="qrda-CommunicationFromPatientToProvider">2.16.840.1.113883.10.20.24.3.2</xsl:variable>
	<xsl:variable name="qrda-CommunicationFromProviderToPatient">2.16.840.1.113883.10.20.24.3.3</xsl:variable>
	<xsl:variable name="qrda-CommunicationFromProviderToProvider">2.16.840.1.113883.10.20.24.3.4</xsl:variable>
	<xsl:variable name="qrda-DeviceAdverseEvent">2.16.840.1.113883.10.20.24.3.5</xsl:variable>
	<xsl:variable name="qrda-DeviceAllergy">2.16.840.1.113883.10.20.24.3.6</xsl:variable>
	<xsl:variable name="qrda-DeviceApplied">2.16.840.1.113883.10.20.24.3.7</xsl:variable>
	<xsl:variable name="qrda-DeviceIntolerance">2.16.840.1.113883.10.20.24.3.8</xsl:variable>
	<xsl:variable name="qrda-DeviceOrder">2.16.840.1.113883.10.20.24.3.9</xsl:variable>
	<xsl:variable name="qrda-DeviceRecommended">2.16.840.1.113883.10.20.24.3.10</xsl:variable>
	<xsl:variable name="qrda-DiagnosisActive">2.16.840.1.113883.10.20.24.3.11</xsl:variable>
	<xsl:variable name="qrda-DiagnosisFamilyHistory">2.16.840.1.113883.10.20.24.3.12 </xsl:variable>
	<xsl:variable name="qrda-DiagnosisInactive">2.16.840.1.113883.10.20.24.3.13</xsl:variable>
	<xsl:variable name="qrda-DiagnosisResolved">2.16.840.1.113883.10.20.24.3.14</xsl:variable>
	<xsl:variable name="qrda-DiagnosticStudyAdverseEvent">2.16.840.1.113883.10.20.24.3.15</xsl:variable>
	<xsl:variable name="qrda-DiagnosticStudyIntolerance">2.16.840.1.113883.10.20.24.3.16</xsl:variable>
	<xsl:variable name="qrda-DiagnosticStudyOrder">2.16.840.1.113883.10.20.24.3.17</xsl:variable>
	<xsl:variable name="qrda-DiagnosticStudyPerformed">2.16.840.1.113883.10.20.24.3.18</xsl:variable>
	<xsl:variable name="qrda-DiagnosticStudyRecommended">2.16.840.1.113883.10.20.24.3.19</xsl:variable>
	<xsl:variable name="qrda-DiagnosticStudyResult">2.16.840.1.113883.10.20.24.3.20</xsl:variable>
	<xsl:variable name="qrda-DischargeMedicationActiveMedication">2.16.840.1.113883.10.20.24.3.105</xsl:variable>
	<xsl:variable name="qrda-EncounterActive">2.16.840.1.113883.10.20.24.3.21</xsl:variable>
	<xsl:variable name="qrda-EncounterOrder">2.16.840.1.113883.10.20.24.3.22</xsl:variable>
	<xsl:variable name="qrda-EncounterPerformed">2.16.840.1.113883.10.20.24.3.23</xsl:variable>
	<xsl:variable name="qrda-EncounterRecommended">2.16.840.1.113883.10.20.24.3.24</xsl:variable>
	<xsl:variable name="qrda-FunctionalStatusOrder">2.16.840.1.113883.10.20.24.3.25</xsl:variable>
	<xsl:variable name="qrda-FunctionalStatusPerformed">2.16.840.1.113883.10.20.24.3.26</xsl:variable>
	<xsl:variable name="qrda-FunctionalStatusRecommended">2.16.840.1.113883.10.20.24.3.27</xsl:variable>
	<xsl:variable name="qrda-FunctionalStatusResult">2.16.840.1.113883.10.20.24.3.28</xsl:variable>
	<xsl:variable name="qrda-FunctionalStatusResultObservation">2.16.840.1.113883.10.20.22.4.67</xsl:variable>
	<xsl:variable name="qrda-IncisionDateTime">2.16.840.1.113883.10.20.24.3.89</xsl:variable>
	<xsl:variable name="qrda-InterventionAdverseEvent">2.16.840.1.113883.10.20.24.3.29</xsl:variable>
	<xsl:variable name="qrda-InterventionIntolerance">2.16.840.1.113883.10.20.24.3.30</xsl:variable>
	<xsl:variable name="qrda-InterventionOrder">2.16.840.1.113883.10.20.24.3.31</xsl:variable>
	<xsl:variable name="qrda-InterventionPerformed">2.16.840.1.113883.10.20.24.3.32</xsl:variable>
	<xsl:variable name="qrda-InterventionRecommended">2.16.840.1.113883.10.20.24.3.33</xsl:variable>
	<xsl:variable name="qrda-InterventionResult">2.16.840.1.113883.10.20.24.3.34</xsl:variable>
	<xsl:variable name="qrda-LaboratoryTestAdverseEvent">2.16.840.1.113883.10.20.24.3.35</xsl:variable>
	<xsl:variable name="qrda-LaboratoryTestIntolerance">2.16.840.1.113883.10.20.24.3.36</xsl:variable>
	<xsl:variable name="qrda-LaboratoryTestOrder">2.16.840.1.113883.10.20.24.3.37</xsl:variable>
	<xsl:variable name="qrda-LaboratoryTestPerformed">2.16.840.1.113883.10.20.24.3.38</xsl:variable>
	<xsl:variable name="qrda-LaboratoryTestRecommended">2.16.840.1.113883.10.20.24.3.39</xsl:variable>
	<xsl:variable name="qrda-LaboratoryTestResult">2.16.840.1.113883.10.20.24.3.40</xsl:variable>
	<xsl:variable name="qrda-MedicationActive">2.16.840.1.113883.10.20.24.3.41</xsl:variable>
	<xsl:variable name="qrda-MedicationAdministered">2.16.840.1.113883.10.20.24.3.42</xsl:variable>
	<xsl:variable name="qrda-MedicationAdverseEffect">2.16.840.1.113883.10.20.24.3.43</xsl:variable>
	<xsl:variable name="qrda-MedicationAllergy">2.16.840.1.113883.10.20.24.3.44</xsl:variable>
	<xsl:variable name="qrda-MedicationDispensed">2.16.840.1.113883.10.20.24.3.45</xsl:variable>
	<xsl:variable name="qrda-MedicationIntolerance">2.16.840.1.113883.10.20.24.3.46</xsl:variable>
	<xsl:variable name="qrda-MedicationOrder">2.16.840.1.113883.10.20.24.3.47</xsl:variable>
	<xsl:variable name="qrda-MedicationSupplyRequest">2.16.840.1.113883.10.20.24.3.99</xsl:variable>
	<xsl:variable name="qrda-NonMedicinalSupplyActivity">2.16.840.1.113883.10.20.22.4.50</xsl:variable>
	<xsl:variable name="qrda-PatientCareExperience">2.16.840.1.113883.10.20.24.3.48</xsl:variable>
	<xsl:variable name="qrda-PatientCharacteristicClinicalTrialParticipant">2.16.840.1.113883.10.20.24.3.51</xsl:variable>
	<xsl:variable name="qrda-PatientCharacteristicEstimatedDateOfConception">2.16.840.1.113883.10.20.24.3.102</xsl:variable>
	<xsl:variable name="qrda-PatientCharacteristicExpired">2.16.840.1.113883.10.20.24.3.54</xsl:variable>
	<xsl:variable name="qrda-PatientCharacteristicGestationalAge">2.16.840.1.113883.10.20.24.3.101</xsl:variable>
	<xsl:variable name="qrda-PatientCharacteristicObservationAssertion">2.16.840.1.113883.10.20.24.3.103</xsl:variable>
	<xsl:variable name="qrda-PatientCharacteristicPayer">2.16.840.1.113883.10.20.24.3.55</xsl:variable>
	<xsl:variable name="qrda-PatientPreference">2.16.840.1.113883.10.20.24.3.83</xsl:variable>
	<xsl:variable name="qrda-PhysicalExamFinding">2.16.840.1.113883.10.20.24.3.57</xsl:variable>
	<xsl:variable name="qrda-PhysicalExamOrder">2.16.840.1.113883.10.20.24.3.58</xsl:variable>
	<xsl:variable name="qrda-PhysicalExamPerformed">2.16.840.1.113883.10.20.24.3.59</xsl:variable>
	<xsl:variable name="qrda-PhysicalExamRecommended">2.16.840.1.113883.10.20.24.3.60</xsl:variable>
	<xsl:variable name="qrda-ProblemStatusActive">2.16.840.1.113883.10.20.24.3.94</xsl:variable>
	<xsl:variable name="qrda-ProblemStatusInactive">2.16.840.1.113883.10.20.24.3.95</xsl:variable>
	<xsl:variable name="qrda-ProblemStatusResolved">2.16.840.1.113883.10.20.24.3.96</xsl:variable>
	<xsl:variable name="qrda-ProcedureAdverseEvent">2.16.840.1.113883.10.20.24.3.61</xsl:variable>
	<xsl:variable name="qrda-ProcedureIntolerance">2.16.840.1.113883.10.20.24.3.62</xsl:variable>
	<xsl:variable name="qrda-ProcedureOrder">2.16.840.1.113883.10.20.24.3.63</xsl:variable>
	<xsl:variable name="qrda-ProcedurePerformed">2.16.840.1.113883.10.20.24.3.64</xsl:variable>
	<xsl:variable name="qrda-ProcedureRecommended">2.16.840.1.113883.10.20.24.3.65</xsl:variable>
	<xsl:variable name="qrda-ProcedureResult">2.16.840.1.113883.10.20.24.3.66</xsl:variable>
	<xsl:variable name="qrda-ProductInstance">2.16.840.1.113883.10.20.22.4.37</xsl:variable>
	<xsl:variable name="qrda-ProviderCareExperience">2.16.840.1.113883.10.20.24.3.67</xsl:variable>
	<xsl:variable name="qrda-ProviderPreference">2.16.840.1.113883.10.20.24.3.84</xsl:variable>
	<xsl:variable name="qrda-RadiationDosageAndDuration">2.16.840.1.113883.10.20.24.3.91</xsl:variable>
	<xsl:variable name="qrda-Reaction">2.16.840.1.113883.10.20.24.3.85</xsl:variable>
	<xsl:variable name="qrda-Reason">2.16.840.1.113883.10.20.24.3.88</xsl:variable>
	<xsl:variable name="qrda-Result">2.16.840.1.113883.10.20.24.3.87</xsl:variable>
	<xsl:variable name="qrda-RiskCategoryAssessment">2.16.840.1.113883.10.20.22.3.69</xsl:variable>
	<xsl:variable name="qrda-Status">2.16.840.1.113883.10.20.24.3.93</xsl:variable>
	<xsl:variable name="qrda-SubstanceOrDeviceAllergyIntoleranceObservation">2.16.840.1.113883.10.20.24.3.90</xsl:variable>
	<xsl:variable name="qrda-SubstanceRecommended">2.16.840.1.113883.10.20.24.3.75</xsl:variable>
	<xsl:variable name="qrda-SymptomActive">2.16.840.1.113883.10.20.24.3.76</xsl:variable>
	<xsl:variable name="qrda-SymptomAssessed">2.16.840.1.113883.10.20.24.3.77</xsl:variable>
	<xsl:variable name="qrda-SymptomInactive">2.16.840.1.113883.10.20.24.3.78</xsl:variable>
	<xsl:variable name="qrda-SymptomResolved">2.16.840.1.113883.10.20.24.3.79</xsl:variable>
	
	<!-- QRDA Supporting Templates -->
	<xsl:variable name="qrda-FacilityLocation">2.16.840.1.113883.10.20.24.3.100</xsl:variable>
	<xsl:variable name="qrda-TransferFrom">2.16.840.1.113883.10.20.24.3.81</xsl:variable>
	<xsl:variable name="qrda-TransferTo">2.16.840.1.113883.10.20.24.3.82</xsl:variable>
</xsl:stylesheet>
