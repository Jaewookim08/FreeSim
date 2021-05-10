Require Import HoareDef MutHeader MutMain0 MutMain1 SimModSem.
Require Import Coqlib.
Require Import Universe.
Require Import Skeleton.
Require Import PCM.
Require Import ModSem Behavior.
Require Import Relation_Definitions.

(*** TODO: export these in Coqlib or Universe ***)
Require Import Relation_Operators.
Require Import RelationPairs.
From ITree Require Import
     Events.MapDefault.
From ExtLib Require Import
     Core.RelDec
     Structures.Maps
     Data.Map.FMapAList.

Require Import HTactics Logic.

Set Implicit Arguments.

Local Open Scope nat_scope.




Section SIMMODSEM.

  Context `{Σ: GRA.t}.

  Let W: Type := ((Σ * Any.t)) * ((Σ * Any.t)).

  Let wf: W -> Prop :=
    mk_wf (fun (_: unit) => (True: iProp)%I) top2 top3.

  Theorem correct: ModPair.sim MutMain1.Main MutMain0.Main.
  Proof.
    econs; ss; [|admit ""].
    i. eapply adequacy_lift.
    econstructor 1 with (wf:=wf); et; ss.
    2: { red. econs; ss. red. uipropall. }
    econs; ss. init.
    unfold mainF, mainBody. harg.
    mDesAll. des; clarify. steps. rewrite Any.upcast_downcast. steps.
    hcall _ _ tt with "*"; ss.
    { iPureIntro. splits; eauto. instantiate (1:=10). ss. }
    { splits; ss. }
    mDesAll. des; clarify. eapply Any.upcast_inj in PURE2. des; clarify. steps.
    hret tt; ss.
    (* TODO: change top2 => pure top in SMod.main *)
    iModIntro. repeat iSplit; ss.
    iStopProof. red. uipropall.
  Qed.

End SIMMODSEM.
