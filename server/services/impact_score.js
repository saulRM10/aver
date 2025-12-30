/**
 * Calculates the Career Impact Score for a single "Win"
 * @param {string} accomplishment - The raw text the user entered
 * @param {Object} jobDescription - The parsed requirements/skills from the JD
 * @returns {Object} scoreBreakdown - The numerical score + logic for "receipts"
 */
async function calculateImpactScore(accomplishment, jobDescription) {
  // 1. SEMANTIC ALIGNMENT CHECK
  // Goal: Does this win actually map to a "Skill Code" or "Responsibility" in the JD?
  // Logic: Use the LLM to compare the accomplishment against the JD's 'Core Competencies'.
  // Example: Win mentions "Testing Hexavalent Chromium" -> Maps to JD "Water Quality Compliance".
  const alignmentScore = await getSemanticMapping(
    accomplishment,
    jobDescription
  );

  // 2. QUANTIFIABLE DATA EXTRACTION
  // Goal: Look for "Hard Evidence" like percentages, dollar amounts, or time-savings.
  // Logic: Regex or NLP to identify digits (%) and impact verbs (increased, saved, reduced).
  // Note: Achievements with numbers are 2x more likely to win a promotion debate.
  const metricWeight = extractMetrics(accomplishment);

  // 3. THE "CREDIBILITY" VERIFIER (The Chrome 6 Shield)
  // Goal: Check for "Receipts"—links, document names, or peer advocates.
  // Logic: Scan for keywords like "per [Name]", "link to [Doc]", or "approved by [Senior]".
  // This turns a "claim" into "evidence."
  const evidenceBonus = scanForReceipts(accomplishment);

  // 4. COMPLEXITY SCORING (Level 1 vs. Level 2)
  // Goal: Determine if this was "part of the job" (Standard) or "Exceeding" (Bonus).
  // Logic: Compare the seniority level of the task in the win vs. the user's current JD level.
  const complexityMultiplier = assessComplexity(accomplishment, jobDescription);

  // 5. AGGREGATE THE FINAL SCORE (Out of 100)
  // We weight Alignment and Evidence highest because those win reviews.
  const finalScore = (
    alignmentScore * 0.4 +
    metricWeight * 0.3 +
    evidenceBonus * 0.2 +
    complexityMultiplier * 0.1
  ).toFixed(0);

  // 6. GENERATE THE "ADVOCACY" TIP
  // Goal: If the score is low, tell the user HOW to fix it before the review.
  // Example: "You mentioned the result, but not who validated it. Add a peer advocate to increase impact."
  const suggestions = generateAdvocacyTips(finalScore, accomplishment);

  return {
    score: finalScore,
    category: getImpactCategory(finalScore), // e.g., "High Impact", "Standard Ops"
    breakdown: { alignmentScore, metricWeight, evidenceBonus },
    suggestions,
  };
}

/** * PROMPT STRATEGY FOR THE LLM:
 * "Act as a critical Executive Reviewer. Grade this accomplishment against
 * the following Job Description requirements. Look for data, not fluff.
 * If the user mentions a specific document or a peer who reviewed the work,
 * award a 20% 'Evidence Bonus'."
 */
