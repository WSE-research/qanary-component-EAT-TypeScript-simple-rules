import { Literal } from "rdf-js";
import { IQanaryMessage } from "./api";
// import { DomainType } from "shared";

import { getEndpoint, getInGraph } from "./message-operations";
import { selectSparql } from "./query-sparql";

/**
 * A raw domain instance returned by the SPARQL query
 */
export interface IRawDomainInstance {
  label: Literal;
  id: Literal;
}

